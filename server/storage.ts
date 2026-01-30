import { eq, and, gte, lte, or, ilike, sql } from "drizzle-orm";
import { db } from "./db";
import {
  wines,
  occasions,
  keywordLib,
  conversations,
  messages,
  type Wine,
  type InsertWine,
  type Occasion,
  type InsertOccasion,
  type Conversation,
  type InsertConversation,
  type Message,
  type InsertMessage,
} from "@shared/schema";

export interface WineFilters {
  type?: string;
  nation?: string;
  occasion?: string;
  priceMin?: number;
  priceMax?: number;
  search?: string;
  limit?: number;
}

export interface IStorage {
  // Wines
  getWines(filters?: WineFilters): Promise<Wine[]>;
  getWineById(id: string): Promise<Wine | undefined>;
  insertWine(wine: InsertWine): Promise<Wine>;
  insertWines(wines: InsertWine[]): Promise<void>;
  getWineCount(): Promise<number>;
  
  // Occasions
  insertOccasion(occasion: InsertOccasion): Promise<Occasion>;
  
  // Conversations
  getOrCreateConversation(): Promise<Conversation>;
  getConversationById(id: number): Promise<Conversation | undefined>;
  
  // Messages
  getMessagesByConversationId(conversationId: number): Promise<Message[]>;
  insertMessage(message: InsertMessage): Promise<Message>;
  
  // Wines for AI context
  getWinesForContext(limit?: number): Promise<Wine[]>;
  searchWinesByKeywords(keywords: string[]): Promise<Wine[]>;
}

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
      conditions.push(ilike(wines.occasionTags, `%${filters.occasion}%`));
    }
    if (filters?.search) {
      conditions.push(
        or(
          ilike(wines.nameKr, `%${filters.search}%`),
          ilike(wines.nameEn, `%${filters.search}%`),
          ilike(wines.varieties, `%${filters.search}%`),
          ilike(wines.nation, `%${filters.search}%`),
          ilike(wines.producer, `%${filters.search}%`)
        )
      );
    }

    const query = db.select().from(wines);
    
    if (conditions.length > 0) {
      return query.where(and(...conditions)).limit(filters?.limit || 100);
    }
    
    return query.limit(filters?.limit || 100);
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

  async insertOccasion(occasion: InsertOccasion): Promise<Occasion> {
    const result = await db.insert(occasions).values(occasion).returning();
    return result[0];
  }

  async getOrCreateConversation(): Promise<Conversation> {
    // Get the most recent conversation or create one
    const existing = await db
      .select()
      .from(conversations)
      .orderBy(sql`created_at DESC`)
      .limit(1);

    if (existing[0]) {
      return existing[0];
    }

    const result = await db
      .insert(conversations)
      .values({ title: "Wine Consultation" })
      .returning();
    return result[0];
  }

  async getConversationById(id: number): Promise<Conversation | undefined> {
    const result = await db.select().from(conversations).where(eq(conversations.id, id)).limit(1);
    return result[0];
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
        ilike(wines.occasionTags, `%${kw}%`),
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
}

export const storage = new DatabaseStorage();
