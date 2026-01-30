import { sql } from "drizzle-orm";
import { pgTable, text, varchar, serial, integer, real, timestamp, jsonb } from "drizzle-orm/pg-core";
import { createInsertSchema } from "drizzle-zod";
import { z } from "zod";

// Wine table - main wine data
export const wines = pgTable("wines", {
  id: varchar("id", { length: 20 }).primaryKey(),
  nameEn: text("name_en"),
  nameKr: text("name_kr").notNull(),
  producer: text("producer"),
  nation: text("nation"),
  region: text("region"),
  varieties: text("varieties"),
  type: text("type"),
  use: text("use"),
  abv: real("abv"),
  sweet: real("sweet"),
  acidity: real("acidity"),
  body: real("body"),
  tannin: real("tannin"),
  price: integer("price"),
  year: text("year"),
  ml: integer("ml"),
  stock: integer("stock"),
  vivinoRating: real("vivino_rating"),
  summary: text("summary"),
  notes: text("notes"),
  description: text("description"),
  tastingNote: text("tasting_note"),
  pairing: text("pairing"),
  occasionTags: text("occasion_tags"),
  sampleGroup: text("sample_group"),
});

// Occasions table - parsed occasion data per wine
export const occasions = pgTable("occasions", {
  id: serial("id").primaryKey(),
  wineId: varchar("wine_id", { length: 20 }).notNull().references(() => wines.id),
  people: text("people"),
  place: text("place"),
  purpose: text("purpose"),
  moodIntensity: text("mood_intensity"),
  timing: text("timing"),
});

// Keyword library for mapping user keywords to filter values
export const keywordLib = pgTable("keyword_lib", {
  id: serial("id").primaryKey(),
  category: text("category").notNull(),
  keyword: text("keyword").notNull(),
  mappedValue: text("mapped_value").notNull(),
});

// Chat conversations for sommelier
export const conversations = pgTable("conversations", {
  id: serial("id").primaryKey(),
  title: text("title").notNull(),
  createdAt: timestamp("created_at").default(sql`CURRENT_TIMESTAMP`).notNull(),
});

// Chat messages
export const messages = pgTable("messages", {
  id: serial("id").primaryKey(),
  conversationId: integer("conversation_id").notNull().references(() => conversations.id, { onDelete: "cascade" }),
  role: text("role").notNull(),
  content: text("content").notNull(),
  wineRecommendations: jsonb("wine_recommendations"),
  createdAt: timestamp("created_at").default(sql`CURRENT_TIMESTAMP`).notNull(),
});

// Insert schemas
export const insertWineSchema = createInsertSchema(wines);
export const insertOccasionSchema = createInsertSchema(occasions).omit({ id: true });
export const insertKeywordLibSchema = createInsertSchema(keywordLib).omit({ id: true });
export const insertConversationSchema = createInsertSchema(conversations).omit({ id: true, createdAt: true });
export const insertMessageSchema = createInsertSchema(messages).omit({ id: true, createdAt: true });

// Types
export type Wine = typeof wines.$inferSelect;
export type InsertWine = z.infer<typeof insertWineSchema>;
export type Occasion = typeof occasions.$inferSelect;
export type InsertOccasion = z.infer<typeof insertOccasionSchema>;
export type KeywordLib = typeof keywordLib.$inferSelect;
export type InsertKeywordLib = z.infer<typeof insertKeywordLibSchema>;
export type Conversation = typeof conversations.$inferSelect;
export type InsertConversation = z.infer<typeof insertConversationSchema>;
export type Message = typeof messages.$inferSelect;
export type InsertMessage = z.infer<typeof insertMessageSchema>;

// Filter types for the UI
export const wineTypes = ["RED", "WHITE", "SPARKLING", "Rose", "Fortified"] as const;
export const priceRanges = [
  { label: "~2만원", min: 0, max: 20000 },
  { label: "2~5만원", min: 20000, max: 50000 },
  { label: "5~10만원", min: 50000, max: 100000 },
  { label: "10~20만원", min: 100000, max: 200000 },
  { label: "20만원~", min: 200000, max: 10000000 },
] as const;

export const occasionOptions = [
  "피크닉", "파티", "혼술", "데이트", "데일리", 
  "행사", "선물", "안주없이", "첫잔", "마무리", "대화용"
] as const;

export const nations = [
  "France", "Italy", "Spain", "USA", "Chile", 
  "Australia", "New Zealand", "Germany", "Portugal", "Argentina"
] as const;

// Legacy user types for compatibility
export const users = pgTable("users", {
  id: varchar("id").primaryKey().default(sql`gen_random_uuid()`),
  username: text("username").notNull().unique(),
  password: text("password").notNull(),
});

export const insertUserSchema = createInsertSchema(users).pick({
  username: true,
  password: true,
});

export type InsertUser = z.infer<typeof insertUserSchema>;
export type User = typeof users.$inferSelect;
