import { eq, and, gte, lte, or, ilike, sql, inArray, desc, isNotNull } from "drizzle-orm";
import { db } from "./db";
import {
  wines,
  occasionTypes,
  wineOccasions,
  keywordLib,
  tasteLevels,
  priceRanges,
  conversations,
  messages,
  users,
  type Wine,
  type InsertWine,
  type OccasionType,
  type InsertOccasionType,
  type WineOccasion,
  type InsertWineOccasion,
  type TasteLevel,
  type PriceRange,
  type Conversation,
  type InsertConversation,
  type Message,
  type InsertMessage,
  type User,
  type InsertUser,
  type SafeUser,
} from "@shared/schema";

// Smart search filter interface for AI queries
export interface SmartSearchFilters {
  type?: string;
  nation?: string;
  occasionIds?: number[];
  priceMin?: number;
  priceMax?: number;
  sweet?: { min?: number; max?: number };
  acidity?: { min?: number; max?: number };
  body?: { min?: number; max?: number };
  tannin?: { min?: number; max?: number };
}

export interface WineFilters {
  type?: string;
  nation?: string;
  occasion?: string;
  priceMin?: number;
  priceMax?: number;
  search?: string;
  limit?: number;
  offset?: number;
}

export interface IStorage {
  // Wines
  getWines(filters?: WineFilters): Promise<Wine[]>;
  getWineById(id: string): Promise<Wine | undefined>;
  insertWine(wine: InsertWine): Promise<Wine>;
  insertWines(wines: InsertWine[]): Promise<void>;
  getWineCount(): Promise<number>;
  getFeaturedWines(limit?: number): Promise<Wine[]>;
  
  // Occasion Types
  getOccasionTypes(): Promise<OccasionType[]>;
  
  // Wine Occasions
  getWineOccasions(wineId: string): Promise<OccasionType[]>;
  
  // Users
  getUserById(id: number): Promise<User | undefined>;
  getUserByEmail(email: string): Promise<User | undefined>;
  createUser(data: { email: string; password: string; name?: string; role?: string }): Promise<User>;
  getAllUsers(): Promise<SafeUser[]>;
  getUserCount(): Promise<number>;
  updateUser(id: number, data: Partial<{ email: string; name: string; role: string }>): Promise<SafeUser | undefined>;
  updateUserPassword(id: number, hashedPassword: string): Promise<void>;
  deleteUser(id: number): Promise<void>;
  
  // Conversations
  getOrCreateConversation(userId?: number): Promise<Conversation>;
  getConversationById(id: number): Promise<Conversation | undefined>;
  getAllConversations(userId?: number): Promise<Conversation[]>;
  createConversation(title: string, userId?: number): Promise<Conversation>;
  deleteConversation(id: number): Promise<void>;
  updateConversationTitle(id: number, title: string): Promise<Conversation | undefined>;
  searchConversations(query: string, userId?: number): Promise<{ conversation: Conversation; matchedMessages: Message[] }[]>;
  
  // Messages
  getMessagesByConversationId(conversationId: number): Promise<Message[]>;
  insertMessage(message: InsertMessage): Promise<Message>;
  
  // Wines for AI context
  getWinesForContext(limit?: number): Promise<Wine[]>;
  searchWinesByKeywords(keywords: string[]): Promise<Wine[]>;
  
  // Smart search for AI - keyword mapping
  getAllTasteLevels(): Promise<TasteLevel[]>;
  getAllPriceRanges(): Promise<PriceRange[]>;
  getAllKeywords(): Promise<{ category: string; key: string; keywords: string[] | null }[]>;
  smartSearchWines(filters: SmartSearchFilters, limit?: number): Promise<Wine[]>;
}

// Korean to English country name mapping for search
const koreanToEnglishCountry: Record<string, string> = {
  "미국": "USA",
  "프랑스": "France",
  "이탈리아": "Italy",
  "스페인": "Spain",
  "독일": "Germany",
  "호주": "Australia",
  "뉴질랜드": "New Zealand",
  "칠레": "Chile",
  "아르헨티나": "Argentina",
  "포르투갈": "Portugal",
  "남아프리카": "South Africa",
  "오스트리아": "Austria",
  "그리스": "Greece",
  "헝가리": "Hungary",
  "일본": "Japan",
  "중국": "China",
  "캐나다": "Canada",
  "영국": "UK",
};

// Korean to English wine type mapping for search
const koreanToEnglishType: Record<string, string> = {
  "레드": "RED",
  "화이트": "WHITE",
  "로제": "ROSE",
  "스파클링": "SPARKLING",
  "디저트": "DESSERT",
  "주정강화": "FORTIFIED",
};

class DatabaseStorage implements IStorage {
  async getWines(filters?: WineFilters): Promise<Wine[]> {
    const conditions = [];

    if (filters?.type) {
      // Use ilike for case-insensitive matching
      conditions.push(ilike(wines.type, `%${filters.type}%`));
    }
    if (filters?.nation) {
      // Use ilike for flexible nation matching (handles variations like "the Republic of South Africa")
      conditions.push(ilike(wines.nation, `%${filters.nation}%`));
    }
    if (filters?.priceMin !== undefined) {
      conditions.push(gte(wines.price, filters.priceMin));
    }
    if (filters?.priceMax !== undefined) {
      conditions.push(lte(wines.price, filters.priceMax));
    }
    if (filters?.occasion) {
      // Use subquery to filter wines by occasion through the junction table
      const wineIdsWithOccasion = db
        .select({ wineId: wineOccasions.wineId })
        .from(wineOccasions)
        .innerJoin(occasionTypes, eq(wineOccasions.occasionId, occasionTypes.id))
        .where(ilike(occasionTypes.occasion, `%${filters.occasion}%`));
      conditions.push(sql`${wines.id} IN (${wineIdsWithOccasion})`);
    }
    if (filters?.search) {
      const searchTerm = filters.search;
      const searchConditions = [
        ilike(wines.nameKr, `%${searchTerm}%`),
        ilike(wines.nameEn, `%${searchTerm}%`),
        ilike(wines.varieties, `%${searchTerm}%`),
        ilike(wines.nation, `%${searchTerm}%`),
        ilike(wines.producer, `%${searchTerm}%`)
      ];
      
      // Check if search term is a Korean country name and add English equivalent
      const englishCountry = koreanToEnglishCountry[searchTerm];
      if (englishCountry) {
        searchConditions.push(ilike(wines.nation, `%${englishCountry}%`));
      }
      
      // Check if search term is a Korean wine type and add English equivalent
      const englishType = koreanToEnglishType[searchTerm];
      if (englishType) {
        searchConditions.push(ilike(wines.type, `%${englishType}%`));
      }
      
      conditions.push(or(...searchConditions));
    }

    const query = db.select().from(wines);
    const limit = filters?.limit || 20;
    const offset = filters?.offset || 0;
    
    if (conditions.length > 0) {
      return query.where(and(...conditions)).limit(limit).offset(offset);
    }
    
    return query.limit(limit).offset(offset);
  }

  async getWineById(id: string): Promise<Wine | undefined> {
    const result = await db.select().from(wines).where(eq(wines.id, id)).limit(1);
    return result[0];
  }

  async insertWine(wine: InsertWine): Promise<Wine> {
    const result = await db.insert(wines).values(wine).returning();
    return result[0];
  }

  async insertWines(wineList: InsertWine[]): Promise<void> {
    if (wineList.length === 0) return;
    
    // Insert in batches of 50 to avoid issues
    const batchSize = 50;
    for (let i = 0; i < wineList.length; i += batchSize) {
      const batch = wineList.slice(i, i + batchSize);
      await db.insert(wines).values(batch).onConflictDoNothing();
    }
  }

  async getWineCount(): Promise<number> {
    const result = await db.select({ count: sql<number>`count(*)` }).from(wines);
    return Number(result[0]?.count || 0);
  }

  async getFeaturedWines(limit = 10): Promise<Wine[]> {
    // Get wines with Vivino rating, sorted by rating descending
    return db
      .select()
      .from(wines)
      .where(isNotNull(wines.vivinoRating))
      .orderBy(desc(wines.vivinoRating))
      .limit(limit);
  }

  async getOccasionTypes(): Promise<OccasionType[]> {
    return db.select().from(occasionTypes);
  }

  async getWineOccasions(wineId: string): Promise<OccasionType[]> {
    const result = await db
      .select()
      .from(wineOccasions)
      .innerJoin(occasionTypes, eq(wineOccasions.occasionId, occasionTypes.id))
      .where(eq(wineOccasions.wineId, wineId));
    return result.map(r => r.occasion_types);
  }

  // User methods
  async getUserById(id: number): Promise<User | undefined> {
    const result = await db.select().from(users).where(eq(users.id, id)).limit(1);
    return result[0];
  }

  async getUserByEmail(email: string): Promise<User | undefined> {
    const result = await db.select().from(users).where(eq(users.email, email)).limit(1);
    return result[0];
  }

  async createUser(data: { email: string; password: string; name?: string; role?: string }): Promise<User> {
    const result = await db.insert(users).values({
      email: data.email,
      password: data.password,
      name: data.name || null,
      role: data.role || "user",
    }).returning();
    return result[0];
  }

  async getAllUsers(): Promise<SafeUser[]> {
    const result = await db.select({
      id: users.id,
      email: users.email,
      name: users.name,
      role: users.role,
      createdAt: users.createdAt,
    }).from(users).orderBy(desc(users.createdAt));
    return result;
  }

  async getUserCount(): Promise<number> {
    const result = await db.select({ count: sql<number>`count(*)` }).from(users);
    return Number(result[0]?.count || 0);
  }

  async updateUser(id: number, data: Partial<{ email: string; name: string; role: string }>): Promise<SafeUser | undefined> {
    const result = await db
      .update(users)
      .set(data)
      .where(eq(users.id, id))
      .returning({
        id: users.id,
        email: users.email,
        name: users.name,
        role: users.role,
        createdAt: users.createdAt,
      });
    return result[0];
  }

  async updateUserPassword(id: number, hashedPassword: string): Promise<void> {
    await db.update(users).set({ password: hashedPassword }).where(eq(users.id, id));
  }

  async deleteUser(id: number): Promise<void> {
    await db.delete(users).where(eq(users.id, id));
  }

  async getOrCreateConversation(userId?: number): Promise<Conversation> {
    // Get the most recent conversation for this user or create one
    const conditions = userId ? eq(conversations.userId, userId) : sql`${conversations.userId} IS NULL`;
    const existing = await db
      .select()
      .from(conversations)
      .where(conditions)
      .orderBy(sql`created_at DESC`)
      .limit(1);

    if (existing[0]) {
      return existing[0];
    }

    const result = await db
      .insert(conversations)
      .values({ title: "Wine Consultation", userId: userId || null })
      .returning();
    return result[0];
  }

  async getConversationById(id: number): Promise<Conversation | undefined> {
    const result = await db.select().from(conversations).where(eq(conversations.id, id)).limit(1);
    return result[0];
  }

  async getAllConversations(userId?: number): Promise<Conversation[]> {
    if (userId) {
      return db.select().from(conversations).where(eq(conversations.userId, userId)).orderBy(sql`created_at DESC`);
    }
    return db.select().from(conversations).orderBy(sql`created_at DESC`);
  }

  async createConversation(title: string, userId?: number): Promise<Conversation> {
    const result = await db.insert(conversations).values({ title, userId: userId || null }).returning();
    return result[0];
  }

  async deleteConversation(id: number): Promise<void> {
    await db.delete(conversations).where(eq(conversations.id, id));
  }

  async updateConversationTitle(id: number, title: string): Promise<Conversation | undefined> {
    const result = await db
      .update(conversations)
      .set({ title })
      .where(eq(conversations.id, id))
      .returning();
    return result[0];
  }

  async searchConversations(query: string, userId?: number): Promise<{ conversation: Conversation; matchedMessages: Message[] }[]> {
    // Get user's conversations first if userId provided
    let userConversationIds: number[] | null = null;
    if (userId) {
      const userConvs = await db.select({ id: conversations.id }).from(conversations).where(eq(conversations.userId, userId));
      userConversationIds = userConvs.map(c => c.id);
      if (userConversationIds.length === 0) return [];
    }

    // Search messages that contain the query
    const baseCondition = ilike(messages.content, `%${query}%`);
    const conditions = userConversationIds 
      ? and(baseCondition, inArray(messages.conversationId, userConversationIds))
      : baseCondition;

    const matchedMessages = await db
      .select()
      .from(messages)
      .where(conditions)
      .orderBy(sql`created_at DESC`);

    // Group by conversation and fetch conversation details
    const conversationMap = new Map<number, Message[]>();
    for (const msg of matchedMessages) {
      if (!conversationMap.has(msg.conversationId)) {
        conversationMap.set(msg.conversationId, []);
      }
      conversationMap.get(msg.conversationId)!.push(msg);
    }

    // Fetch conversation details
    const results: { conversation: Conversation; matchedMessages: Message[] }[] = [];
    const entries = Array.from(conversationMap.entries());
    for (const [convId, msgs] of entries) {
      const conv = await this.getConversationById(convId);
      if (conv) {
        results.push({ conversation: conv, matchedMessages: msgs });
      }
    }

    return results;
  }

  async getMessagesByConversationId(conversationId: number): Promise<Message[]> {
    return db
      .select()
      .from(messages)
      .where(eq(messages.conversationId, conversationId))
      .orderBy(sql`created_at ASC`);
  }

  async insertMessage(message: InsertMessage): Promise<Message> {
    const result = await db.insert(messages).values(message).returning();
    return result[0];
  }

  async getWinesForContext(limit = 50): Promise<Wine[]> {
    return db.select().from(wines).limit(limit);
  }

  async searchWinesByKeywords(keywords: string[]): Promise<Wine[]> {
    if (keywords.length === 0) return [];

    const conditions = keywords.map((kw) =>
      or(
        ilike(wines.nameKr, `%${kw}%`),
        ilike(wines.summary, `%${kw}%`),
        ilike(wines.tastingNote, `%${kw}%`),
        ilike(wines.varieties, `%${kw}%`),
        ilike(wines.type, `%${kw}%`),
        ilike(wines.nation, `%${kw}%`)
      )
    );

    return db
      .select()
      .from(wines)
      .where(or(...conditions))
      .limit(20);
  }

  async getAllTasteLevels(): Promise<TasteLevel[]> {
    return db.select().from(tasteLevels);
  }

  async getAllPriceRanges(): Promise<PriceRange[]> {
    return db.select().from(priceRanges).orderBy(priceRanges.minPrice);
  }

  async getAllKeywords(): Promise<{ category: string; key: string; keywords: string[] | null }[]> {
    return db.select({
      category: keywordLib.category,
      key: keywordLib.key,
      keywords: keywordLib.keywords,
    }).from(keywordLib);
  }

  async smartSearchWines(filters: SmartSearchFilters, limit = 30): Promise<Wine[]> {
    const conditions = [];

    if (filters.type) {
      conditions.push(ilike(wines.type, `%${filters.type}%`));
    }
    if (filters.nation) {
      conditions.push(ilike(wines.nation, `%${filters.nation}%`));
    }
    if (filters.priceMin !== undefined) {
      conditions.push(gte(wines.price, filters.priceMin));
    }
    if (filters.priceMax !== undefined) {
      conditions.push(lte(wines.price, filters.priceMax));
    }
    if (filters.sweet?.min !== undefined) {
      conditions.push(gte(wines.sweet, filters.sweet.min));
    }
    if (filters.sweet?.max !== undefined) {
      conditions.push(lte(wines.sweet, filters.sweet.max));
    }
    if (filters.acidity?.min !== undefined) {
      conditions.push(gte(wines.acidity, filters.acidity.min));
    }
    if (filters.acidity?.max !== undefined) {
      conditions.push(lte(wines.acidity, filters.acidity.max));
    }
    if (filters.body?.min !== undefined) {
      conditions.push(gte(wines.body, filters.body.min));
    }
    if (filters.body?.max !== undefined) {
      conditions.push(lte(wines.body, filters.body.max));
    }
    if (filters.tannin?.min !== undefined) {
      conditions.push(gte(wines.tannin, filters.tannin.min));
    }
    if (filters.tannin?.max !== undefined) {
      conditions.push(lte(wines.tannin, filters.tannin.max));
    }
    if (filters.occasionIds && filters.occasionIds.length > 0) {
      const wineIdsWithOccasion = db
        .select({ wineId: wineOccasions.wineId })
        .from(wineOccasions)
        .where(inArray(wineOccasions.occasionId, filters.occasionIds));
      conditions.push(sql`${wines.id} IN (${wineIdsWithOccasion})`);
    }

    const query = db.select().from(wines);
    
    if (conditions.length > 0) {
      return query.where(and(...conditions)).limit(limit);
    }
    
    return query.limit(limit);
  }
}

export const storage = new DatabaseStorage();
