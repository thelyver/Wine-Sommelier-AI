import type { Express, Request, Response } from "express";
import { createServer, type Server } from "http";
import OpenAI from "openai";
import bcrypt from "bcryptjs";
import { storage, type SmartSearchFilters } from "./storage";
import { registerUserSchema, loginUserSchema, type SafeUser } from "@shared/schema";

// Extend express-session types
declare module "express-session" {
  interface SessionData {
    userId?: number;
  }
}

const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY,
});

// Cache for keyword data (loaded once at startup)
let keywordCache: {
  tasteLevels: { attribute: string; level: number; keywords: string[] | null }[];
  priceRanges: { rangeName: string; minPrice: number; maxPrice: number; keywords: string[] | null }[];
  keywords: { category: string; key: string; keywords: string[] | null }[];
  occasions: { id: number; occasion: string; keywords: string[] | null }[];
} | null = null;

async function loadKeywordCache() {
  if (keywordCache) return keywordCache;
  
  const [tasteLevels, priceRanges, keywords, occasions] = await Promise.all([
    storage.getAllTasteLevels(),
    storage.getAllPriceRanges(),
    storage.getAllKeywords(),
    storage.getOccasionTypes(),
  ]);
  
  keywordCache = { tasteLevels, priceRanges, keywords, occasions };
  return keywordCache;
}

// Analyze user query and extract filters
async function analyzeQueryForFilters(userQuery: string): Promise<SmartSearchFilters> {
  const cache = await loadKeywordCache();
  const filters: SmartSearchFilters = {};
  const queryLower = userQuery.toLowerCase();
  
  // Match taste levels (sweet, acidity, body, tannin)
  for (const taste of cache.tasteLevels) {
    if (taste.keywords) {
      for (const kw of taste.keywords) {
        if (queryLower.includes(kw.toLowerCase())) {
          const attr = taste.attribute as 'sweet' | 'acidity' | 'body' | 'tannin';
          if (!filters[attr]) filters[attr] = {};
          filters[attr]!.min = taste.level;
          break;
        }
      }
    }
  }
  
  // Match price ranges
  for (const range of cache.priceRanges) {
    if (range.keywords) {
      for (const kw of range.keywords) {
        if (queryLower.includes(kw.toLowerCase())) {
          filters.priceMin = range.minPrice;
          filters.priceMax = range.maxPrice;
          break;
        }
      }
    }
  }
  
  // Match occasions
  const matchedOccasionIds: number[] = [];
  for (const occ of cache.occasions) {
    if (queryLower.includes(occ.occasion.toLowerCase())) {
      matchedOccasionIds.push(occ.id);
    }
    if (occ.keywords) {
      for (const kw of occ.keywords) {
        if (queryLower.includes(kw.toLowerCase())) {
          matchedOccasionIds.push(occ.id);
          break;
        }
      }
    }
  }
  if (matchedOccasionIds.length > 0) {
    filters.occasionIds = Array.from(new Set(matchedOccasionIds));
  }
  
  // Match type and nation from keyword_lib
  for (const kw of cache.keywords) {
    if (kw.keywords) {
      for (const keyword of kw.keywords) {
        if (queryLower.includes(keyword.toLowerCase())) {
          if (kw.category === 'type') {
            filters.type = kw.key;
          } else if (kw.category === 'nation') {
            filters.nation = kw.key;
          }
          break;
        }
      }
    }
  }
  
  // Direct type matching
  const typeMap: Record<string, string> = {
    '레드': 'RED', '화이트': 'WHITE', '스파클링': 'SPARKLING',
    '로제': 'Rose', '주정강화': 'Fortified',
    'red': 'RED', 'white': 'WHITE', 'sparkling': 'SPARKLING',
    'rose': 'Rose', 'rosé': 'Rose'
  };
  for (const [keyword, type] of Object.entries(typeMap)) {
    if (queryLower.includes(keyword)) {
      filters.type = type;
      break;
    }
  }
  
  return filters;
}

// System prompt loaded from attached file
const SOMMELIER_BASE_PROMPT = `당신은 전문 와인 소믈리에다.

당신은 반드시 데이터베이스에 존재하는 와인만 추천해야 한다.
데이터베이스에 없는 와인을 만들어내서는 안 된다.

당신의 역할은 다음과 같다.
1. 사용자의 상황과 의도를 이해한다.
2. 사용자의 표현을 occasion, taste, price, type 등의 구조화된 속성으로 해석한다.
3. 조건에 맞는 와인을 데이터베이스에서 선택한다.
4. 전문 소믈리에의 말투로 추천 이유를 설명한다.

항상 다음을 포함해서 설명한다.
- 이 와인이 왜 이 상황에 적합한지
- 어떤 맛과 분위기를 기대할 수 있는지

과도한 광고 표현이나 허위 정보는 사용하지 않는다.`;

function buildSommelierPrompt(wineContext: string): string {
  return `${SOMMELIER_BASE_PROMPT}

## 응답 형식 규칙:
1. 마크다운 형식으로 응답하세요.
2. 와인을 추천할 때 와인명만 사용하고, 와인 ID는 대괄호 링크 형식으로 숨기세요.
   예시: [르 모레 모스카토 피에몬테 아스티 2018](#wine-ta155)
3. 와인 ID(ta001 등)를 직접 텍스트로 노출하지 마세요. 항상 링크 형식으로 숨기세요.
4. 추천하는 와인은 반드시 아래 목록에 있는 것만 선택해야 합니다.

현재 데이터베이스에 있는 와인 목록:
${wineContext}

사용자의 질문에 맞는 와인을 위 목록에서 선택하여 추천하세요. 목록에 없는 와인은 절대 추천하지 마세요.`;
}

export async function registerRoutes(
  httpServer: Server,
  app: Express
): Promise<Server> {
  // Get wines with filters
  app.get("/api/wines", async (req: Request, res: Response) => {
    try {
      const filters = {
        type: req.query.type as string | undefined,
        nation: req.query.nation as string | undefined,
        occasion: req.query.occasion as string | undefined,
        priceMin: req.query.priceMin ? parseInt(req.query.priceMin as string) : undefined,
        priceMax: req.query.priceMax ? parseInt(req.query.priceMax as string) : undefined,
        search: req.query.search as string | undefined,
        limit: req.query.limit ? parseInt(req.query.limit as string) : 20,
        offset: req.query.offset ? parseInt(req.query.offset as string) : 0,
      };

      const wines = await storage.getWines(filters);
      res.json(wines);
    } catch (error) {
      console.error("Error fetching wines:", error);
      res.status(500).json({ error: "Failed to fetch wines" });
    }
  });

  // Get featured wines (sorted by Vivino rating)
  app.get("/api/wines/featured", async (req: Request, res: Response) => {
    try {
      const limit = req.query.limit ? parseInt(req.query.limit as string) : 10;
      const wines = await storage.getFeaturedWines(limit);
      res.json(wines);
    } catch (error) {
      console.error("Error fetching featured wines:", error);
      res.status(500).json({ error: "Failed to fetch featured wines" });
    }
  });

  // Get single wine by ID
  app.get("/api/wines/:id", async (req: Request, res: Response) => {
    try {
      const wine = await storage.getWineById(req.params.id as string);
      if (!wine) {
        return res.status(404).json({ error: "Wine not found" });
      }
      res.json(wine);
    } catch (error) {
      console.error("Error fetching wine:", error);
      res.status(500).json({ error: "Failed to fetch wine" });
    }
  });

  // Get wine occasions
  app.get("/api/wines/:id/occasions", async (req: Request, res: Response) => {
    try {
      const occasions = await storage.getWineOccasions(req.params.id as string);
      res.json(occasions);
    } catch (error) {
      console.error("Error fetching wine occasions:", error);
      res.status(500).json({ error: "Failed to fetch wine occasions" });
    }
  });

  // Get all occasion types
  app.get("/api/occasions", async (_req: Request, res: Response) => {
    try {
      const occasions = await storage.getOccasionTypes();
      res.json(occasions);
    } catch (error) {
      console.error("Error fetching occasions:", error);
      res.status(500).json({ error: "Failed to fetch occasions" });
    }
  });

  // Get or create conversation
  app.get("/api/sommelier/conversation", async (_req: Request, res: Response) => {
    try {
      const conversation = await storage.getOrCreateConversation();
      res.json(conversation);
    } catch (error) {
      console.error("Error getting conversation:", error);
      res.status(500).json({ error: "Failed to get conversation" });
    }
  });

  // Get all conversations
  app.get("/api/sommelier/conversations", async (_req: Request, res: Response) => {
    try {
      const allConversations = await storage.getAllConversations();
      res.json(allConversations);
    } catch (error) {
      console.error("Error fetching conversations:", error);
      res.status(500).json({ error: "Failed to fetch conversations" });
    }
  });

  // Create new conversation
  app.post("/api/sommelier/conversations", async (req: Request, res: Response) => {
    try {
      const { title } = req.body;
      const conversation = await storage.createConversation(title || "새 대화");
      res.json(conversation);
    } catch (error) {
      console.error("Error creating conversation:", error);
      res.status(500).json({ error: "Failed to create conversation" });
    }
  });

  // Delete conversation
  app.delete("/api/sommelier/conversations/:id", async (req: Request, res: Response) => {
    try {
      const id = parseInt(req.params.id as string);
      if (isNaN(id)) {
        return res.status(400).json({ error: "Invalid conversation ID" });
      }
      await storage.deleteConversation(id);
      res.json({ success: true });
    } catch (error) {
      console.error("Error deleting conversation:", error);
      res.status(500).json({ error: "Failed to delete conversation" });
    }
  });

  // Update conversation title
  app.patch("/api/sommelier/conversations/:id", async (req: Request, res: Response) => {
    try {
      const id = parseInt(req.params.id as string);
      const { title } = req.body;
      if (isNaN(id)) {
        return res.status(400).json({ error: "Invalid conversation ID" });
      }
      const conversation = await storage.updateConversationTitle(id, title);
      res.json(conversation);
    } catch (error) {
      console.error("Error updating conversation:", error);
      res.status(500).json({ error: "Failed to update conversation" });
    }
  });

  // Search conversations
  app.get("/api/sommelier/search", async (req: Request, res: Response) => {
    try {
      const query = req.query.q as string;
      if (!query) {
        return res.status(400).json({ error: "Search query is required" });
      }
      const results = await storage.searchConversations(query);
      res.json(results);
    } catch (error) {
      console.error("Error searching conversations:", error);
      res.status(500).json({ error: "Failed to search conversations" });
    }
  });

  // Get messages for a conversation (with path parameter)
  app.get("/api/sommelier/messages/:conversationId", async (req: Request, res: Response) => {
    try {
      const conversationId = parseInt(req.params.conversationId as string);
      if (isNaN(conversationId)) {
        return res.status(400).json({ error: "Invalid conversation ID" });
      }
      const messages = await storage.getMessagesByConversationId(conversationId);
      res.json(messages);
    } catch (error) {
      console.error("Error fetching messages:", error);
      res.status(500).json({ error: "Failed to fetch messages" });
    }
  });

  // Get messages for a conversation (with query parameter - legacy support)
  app.get("/api/sommelier/messages", async (req: Request, res: Response) => {
    try {
      const conversationId = parseInt(req.query.conversationId as string);
      if (isNaN(conversationId)) {
        return res.status(400).json({ error: "Invalid conversation ID" });
      }
      const messages = await storage.getMessagesByConversationId(conversationId);
      res.json(messages);
    } catch (error) {
      console.error("Error fetching messages:", error);
      res.status(500).json({ error: "Failed to fetch messages" });
    }
  });

  // Chat with sommelier (streaming)
  app.post("/api/sommelier/chat", async (req: Request, res: Response) => {
    try {
      const { conversationId, content } = req.body;

      if (!conversationId || !content) {
        return res.status(400).json({ error: "Missing conversationId or content" });
      }

      // Save user message
      await storage.insertMessage({
        conversationId,
        role: "user",
        content,
      });

      // Analyze user query and extract filters
      const filters = await analyzeQueryForFilters(content);
      console.log("Extracted filters from query:", JSON.stringify(filters));
      
      // Smart search wines based on extracted filters
      let wines;
      const hasFilters = Object.keys(filters).length > 0;
      
      if (hasFilters) {
        wines = await storage.smartSearchWines(filters, 30);
        console.log(`Smart search found ${wines.length} wines matching filters`);
        
        // If smart search returns too few results, supplement with general wines
        if (wines.length < 10) {
          const generalWines = await storage.getWinesForContext(30);
          const wineIds = new Set(wines.map(w => w.id));
          const additionalWines = generalWines.filter(w => !wineIds.has(w.id));
          wines = [...wines, ...additionalWines.slice(0, 20 - wines.length)];
        }
      } else {
        // No specific filters found, get general wine context
        wines = await storage.getWinesForContext(50);
      }
      
      const wineContext = wines
        .map(
          (w) =>
            `- ${w.nameKr} (${w.id}): ${w.type || ""}, ${w.nation || ""}, ${w.varieties || ""}, ` +
            `${w.price ? w.price.toLocaleString() + "원" : "가격미정"}, ` +
            `단맛:${w.sweet || 0}/5 산미:${w.acidity || 0}/5 바디:${w.body || 0}/5 탄닌:${w.tannin || 0}/5, ` +
            `${w.summary || ""}`
        )
        .join("\n");

      const filterSummary = hasFilters 
        ? `\n\n[검색 조건에 맞는 와인 ${wines.length}개가 검색되었습니다]` 
        : "";
      
      const systemPrompt = buildSommelierPrompt(wineContext + filterSummary);

      // Get previous messages for context
      const previousMessages = await storage.getMessagesByConversationId(conversationId);
      const chatMessages: OpenAI.ChatCompletionMessageParam[] = [
        { role: "system", content: systemPrompt },
        ...previousMessages.slice(-10).map((m) => ({
          role: m.role as "user" | "assistant",
          content: m.content,
        })),
      ];

      // Set up SSE
      res.setHeader("Content-Type", "text/event-stream");
      res.setHeader("Cache-Control", "no-cache");
      res.setHeader("Connection", "keep-alive");

      // Stream response
      const stream = await openai.chat.completions.create({
        model: "gpt-4o-mini",
        messages: chatMessages,
        stream: true,
        max_completion_tokens: 1000,
      });

      let fullContent = "";

      for await (const chunk of stream) {
        const content = chunk.choices[0]?.delta?.content || "";
        if (content) {
          fullContent += content;
          res.write(`data: ${JSON.stringify({ content })}\n\n`);
        }
      }

      // Save assistant message
      await storage.insertMessage({
        conversationId,
        role: "assistant",
        content: fullContent,
      });

      res.write(`data: ${JSON.stringify({ done: true })}\n\n`);
      res.end();
    } catch (error) {
      console.error("Error in chat:", error);
      if (!res.headersSent) {
        res.status(500).json({ error: "Failed to process chat" });
      } else {
        res.write(`data: ${JSON.stringify({ error: "Failed to process chat" })}\n\n`);
        res.end();
      }
    }
  });

  // Guest chat endpoint (no authentication required, no DB persistence)
  app.post("/api/sommelier/chat/guest", async (req: Request, res: Response) => {
    try {
      const { content, history = [] } = req.body;

      if (!content) {
        return res.status(400).json({ error: "Missing content" });
      }

      // Sanitize history: only allow user/assistant roles (prevent prompt injection)
      const sanitizedHistory = (history as { role: string; content: string }[])
        .filter(m => m.role === "user" || m.role === "assistant")
        .slice(-10)
        .map(m => ({
          role: m.role as "user" | "assistant",
          content: String(m.content).slice(0, 5000), // Limit content length
        }));

      // Analyze user query and extract filters
      const filters = await analyzeQueryForFilters(content);
      console.log("Guest chat - Extracted filters:", JSON.stringify(filters));
      
      // Smart search wines based on extracted filters
      let wines;
      const hasFilters = Object.keys(filters).length > 0;
      
      if (hasFilters) {
        wines = await storage.smartSearchWines(filters, 30);
        console.log(`Smart search found ${wines.length} wines matching filters`);
        
        if (wines.length < 10) {
          const generalWines = await storage.getWinesForContext(30);
          const wineIds = new Set(wines.map(w => w.id));
          const additionalWines = generalWines.filter(w => !wineIds.has(w.id));
          wines = [...wines, ...additionalWines.slice(0, 20 - wines.length)];
        }
      } else {
        wines = await storage.getWinesForContext(50);
      }
      
      const wineContext = wines
        .map(
          (w) =>
            `- ${w.nameKr} (${w.id}): ${w.type || ""}, ${w.nation || ""}, ${w.varieties || ""}, ` +
            `${w.price ? w.price.toLocaleString() + "원" : "가격미정"}, ` +
            `단맛:${w.sweet || 0}/5 산미:${w.acidity || 0}/5 바디:${w.body || 0}/5 탄닌:${w.tannin || 0}/5, ` +
            `${w.summary || ""}`
        )
        .join("\n");

      const filterSummary = hasFilters 
        ? `\n\n[검색 조건에 맞는 와인 ${wines.length}개가 검색되었습니다]` 
        : "";
      
      const systemPrompt = buildSommelierPrompt(wineContext + filterSummary);

      // Use sanitized history from client
      const chatMessages: OpenAI.ChatCompletionMessageParam[] = [
        { role: "system", content: systemPrompt },
        ...sanitizedHistory,
        { role: "user", content },
      ];

      // Set up SSE
      res.setHeader("Content-Type", "text/event-stream");
      res.setHeader("Cache-Control", "no-cache");
      res.setHeader("Connection", "keep-alive");

      // Stream response
      const stream = await openai.chat.completions.create({
        model: "gpt-4o-mini",
        messages: chatMessages,
        stream: true,
        max_completion_tokens: 1000,
      });

      let fullContent = "";

      for await (const chunk of stream) {
        const chunkContent = chunk.choices[0]?.delta?.content || "";
        if (chunkContent) {
          fullContent += chunkContent;
          res.write(`data: ${JSON.stringify({ content: chunkContent })}\n\n`);
        }
      }

      res.write(`data: ${JSON.stringify({ done: true })}\n\n`);
      res.end();
    } catch (error) {
      console.error("Error in guest chat:", error);
      if (!res.headersSent) {
        res.status(500).json({ error: "Failed to process chat" });
      } else {
        res.write(`data: ${JSON.stringify({ error: "Failed to process chat" })}\n\n`);
        res.end();
      }
    }
  });

  // Database stats
  app.get("/api/stats", async (_req: Request, res: Response) => {
    try {
      const wineCount = await storage.getWineCount();
      res.json({ wineCount });
    } catch (error) {
      console.error("Error fetching stats:", error);
      res.status(500).json({ error: "Failed to fetch stats" });
    }
  });

  // ============ AUTH ROUTES ============

  // Register new user
  app.post("/api/auth/register", async (req: Request, res: Response) => {
    try {
      const parsed = registerUserSchema.safeParse(req.body);
      if (!parsed.success) {
        return res.status(400).json({ error: "유효하지 않은 입력입니다.", details: parsed.error.errors });
      }

      const { email, password, name } = parsed.data;

      // Check if user already exists
      const existingUser = await storage.getUserByEmail(email);
      if (existingUser) {
        return res.status(400).json({ error: "이미 사용 중인 이메일입니다." });
      }

      // Hash password
      const hashedPassword = await bcrypt.hash(password, 10);

      // Check if this is the first user (make them admin)
      const userCount = await storage.getUserCount();
      const isFirstUser = userCount === 0;

      // Create user
      const user = await storage.createUser({
        email,
        password: hashedPassword,
        name,
        role: isFirstUser ? "admin" : "user",
      });

      // Set session
      req.session.userId = user.id;

      // Return safe user (without password)
      const safeUser: SafeUser = {
        id: user.id,
        email: user.email,
        name: user.name,
        role: user.role,
        createdAt: user.createdAt,
      };

      res.status(201).json(safeUser);
    } catch (error) {
      console.error("Error registering user:", error);
      res.status(500).json({ error: "회원가입에 실패했습니다." });
    }
  });

  // Login
  app.post("/api/auth/login", async (req: Request, res: Response) => {
    try {
      const parsed = loginUserSchema.safeParse(req.body);
      if (!parsed.success) {
        return res.status(400).json({ error: "유효하지 않은 입력입니다." });
      }

      const { email, password } = parsed.data;

      // Find user
      const user = await storage.getUserByEmail(email);
      if (!user) {
        return res.status(401).json({ error: "이메일 또는 비밀번호가 올바르지 않습니다." });
      }

      // Verify password
      const isValidPassword = await bcrypt.compare(password, user.password);
      if (!isValidPassword) {
        return res.status(401).json({ error: "이메일 또는 비밀번호가 올바르지 않습니다." });
      }

      // Set session
      req.session.userId = user.id;

      // Return safe user
      const safeUser: SafeUser = {
        id: user.id,
        email: user.email,
        name: user.name,
        role: user.role,
        createdAt: user.createdAt,
      };

      res.json(safeUser);
    } catch (error) {
      console.error("Error logging in:", error);
      res.status(500).json({ error: "로그인에 실패했습니다." });
    }
  });

  // Logout
  app.post("/api/auth/logout", (req: Request, res: Response) => {
    req.session.destroy((err) => {
      if (err) {
        console.error("Error logging out:", err);
        return res.status(500).json({ error: "로그아웃에 실패했습니다." });
      }
      res.clearCookie("connect.sid");
      res.json({ success: true });
    });
  });

  // Get current user
  app.get("/api/auth/me", async (req: Request, res: Response) => {
    try {
      if (!req.session.userId) {
        return res.json(null);
      }

      const user = await storage.getUserById(req.session.userId);
      if (!user) {
        return res.json(null);
      }

      const safeUser: SafeUser = {
        id: user.id,
        email: user.email,
        name: user.name,
        role: user.role,
        createdAt: user.createdAt,
      };

      res.json(safeUser);
    } catch (error) {
      console.error("Error getting current user:", error);
      res.status(500).json({ error: "사용자 정보를 가져오는데 실패했습니다." });
    }
  });

  // Change password
  app.post("/api/auth/change-password", async (req: Request, res: Response) => {
    try {
      if (!req.session.userId) {
        return res.status(401).json({ error: "로그인이 필요합니다." });
      }

      const { currentPassword, newPassword } = req.body;

      if (!currentPassword || !newPassword) {
        return res.status(400).json({ error: "현재 비밀번호와 새 비밀번호를 입력해주세요." });
      }

      if (newPassword.length < 6) {
        return res.status(400).json({ error: "새 비밀번호는 6자 이상이어야 합니다." });
      }

      // Get user
      const user = await storage.getUserById(req.session.userId);
      if (!user) {
        return res.status(404).json({ error: "사용자를 찾을 수 없습니다." });
      }

      // Verify current password
      const isValidPassword = await bcrypt.compare(currentPassword, user.password);
      if (!isValidPassword) {
        return res.status(401).json({ error: "현재 비밀번호가 올바르지 않습니다." });
      }

      // Hash new password
      const hashedPassword = await bcrypt.hash(newPassword, 10);

      // Update password
      await storage.updateUserPassword(user.id, hashedPassword);

      res.json({ success: true, message: "비밀번호가 변경되었습니다." });
    } catch (error) {
      console.error("Error changing password:", error);
      res.status(500).json({ error: "비밀번호 변경에 실패했습니다." });
    }
  });

  // ============ ADMIN ROUTES ============

  // Middleware to check if user is admin
  const requireAdmin = async (req: Request, res: Response, next: Function) => {
    if (!req.session.userId) {
      return res.status(401).json({ error: "로그인이 필요합니다." });
    }
    const user = await storage.getUserById(req.session.userId);
    if (!user || user.role !== "admin") {
      return res.status(403).json({ error: "관리자 권한이 필요합니다." });
    }
    next();
  };

  // Get all users (admin only)
  app.get("/api/admin/users", requireAdmin, async (_req: Request, res: Response) => {
    try {
      const users = await storage.getAllUsers();
      res.json(users);
    } catch (error) {
      console.error("Error fetching users:", error);
      res.status(500).json({ error: "사용자 목록을 가져오는데 실패했습니다." });
    }
  });

  // Update user (admin only)
  app.patch("/api/admin/users/:id", requireAdmin, async (req: Request, res: Response) => {
    try {
      const id = parseInt(req.params.id as string);
      if (isNaN(id)) {
        return res.status(400).json({ error: "유효하지 않은 사용자 ID입니다." });
      }

      const { email, name, role } = req.body;
      const updatedUser = await storage.updateUser(id, { email, name, role });
      
      if (!updatedUser) {
        return res.status(404).json({ error: "사용자를 찾을 수 없습니다." });
      }

      res.json(updatedUser);
    } catch (error) {
      console.error("Error updating user:", error);
      res.status(500).json({ error: "사용자 정보 수정에 실패했습니다." });
    }
  });

  // Delete user (admin only)
  app.delete("/api/admin/users/:id", requireAdmin, async (req: Request, res: Response) => {
    try {
      const id = parseInt(req.params.id as string);
      if (isNaN(id)) {
        return res.status(400).json({ error: "유효하지 않은 사용자 ID입니다." });
      }

      await storage.deleteUser(id);
      res.json({ success: true });
    } catch (error) {
      console.error("Error deleting user:", error);
      res.status(500).json({ error: "사용자 삭제에 실패했습니다." });
    }
  });

  // Reset user password (admin only)
  app.post("/api/admin/users/:id/reset-password", requireAdmin, async (req: Request, res: Response) => {
    try {
      const id = parseInt(req.params.id as string);
      if (isNaN(id)) {
        return res.status(400).json({ error: "유효하지 않은 사용자 ID입니다." });
      }

      const { newPassword } = req.body;
      if (!newPassword || newPassword.length < 6) {
        return res.status(400).json({ error: "새 비밀번호는 6자 이상이어야 합니다." });
      }

      const targetUser = await storage.getUserById(id);
      if (!targetUser) {
        return res.status(404).json({ error: "사용자를 찾을 수 없습니다." });
      }

      const hashedPassword = await bcrypt.hash(newPassword, 10);
      await storage.updateUserPassword(id, hashedPassword);

      res.json({ success: true, message: "비밀번호가 초기화되었습니다." });
    } catch (error) {
      console.error("Error resetting password:", error);
      res.status(500).json({ error: "비밀번호 초기화에 실패했습니다." });
    }
  });

  return httpServer;
}
