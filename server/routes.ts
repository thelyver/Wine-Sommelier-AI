import type { Express, Request, Response } from "express";
import { createServer, type Server } from "http";
import OpenAI from "openai";
import { storage } from "./storage";

const openai = new OpenAI({
  apiKey: process.env.AI_INTEGRATIONS_OPENAI_API_KEY,
  baseURL: process.env.AI_INTEGRATIONS_OPENAI_BASE_URL,
});

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

중요: 와인을 추천할 때 반드시 와인 ID(예: ta001, ta002)를 포함해서 언급해주세요. 
추천하는 와인은 반드시 아래 목록에 있는 것만 선택해야 합니다.

현재 데이터베이스에 있는 와인 목록:
${wineContext}

사용자의 질문에 맞는 와인을 위 목록에서 선택하여 추천하세요. 목록에 없는 와인은 절대 추천하지 마세요.
추천 시 와인 ID와 한글 이름을 함께 언급해주세요.`;
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
        limit: req.query.limit ? parseInt(req.query.limit as string) : 100,
      };

      const wines = await storage.getWines(filters);
      res.json(wines);
    } catch (error) {
      console.error("Error fetching wines:", error);
      res.status(500).json({ error: "Failed to fetch wines" });
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

  // Get messages for a conversation
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

      // Get wine context - include relevant wines
      const wines = await storage.getWinesForContext(100);
      const wineContext = wines
        .map(
          (w) =>
            `- ${w.nameKr} (${w.id}): ${w.type || ""}, ${w.nation || ""}, ${w.varieties || ""}, ${w.price ? w.price.toLocaleString() + "원" : "가격미정"}, ${w.summary || ""}`
        )
        .join("\n");

      const systemPrompt = buildSommelierPrompt(wineContext);

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
        model: "gpt-5.2",
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

  return httpServer;
}
