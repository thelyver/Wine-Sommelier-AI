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
  sampleGroup: text("sample_group"),
});

// Occasion types master table - from KeywordLib_occasion CSV
export const occasionTypes = pgTable("occasion_types", {
  id: serial("id").primaryKey(),
  occasion: text("occasion").notNull().unique(),
  occasionEn: text("occasion_en"),
  description: text("description"),
  useHint: text("use_hint"),
  keywords: text("keywords").array(),
});

// Wine-Occasion junction table for many-to-many relationship
export const wineOccasions = pgTable("wine_occasions", {
  id: serial("id").primaryKey(),
  wineId: varchar("wine_id", { length: 20 }).notNull().references(() => wines.id),
  occasionId: integer("occasion_id").notNull().references(() => occasionTypes.id),
});

// Keyword library for mapping user keywords to filter values
// Categories: nation, type, use (taste and price moved to dedicated tables)
export const keywordLib = pgTable("keyword_lib", {
  id: serial("id").primaryKey(),
  category: text("category").notNull(),
  key: text("key").notNull(),
  keywords: text("keywords").array(),
});

// Taste levels - maps wine taste attributes (sweet, acidity, body, tannin) levels 1-5 to keywords
export const tasteLevels = pgTable("taste_levels", {
  id: serial("id").primaryKey(),
  attribute: text("attribute").notNull(), // sweet, acidity, body, tannin
  level: integer("level").notNull(), // 1-5
  keywords: text("keywords").array(),
});

// Price ranges - maps price ranges to keywords
export const priceRanges = pgTable("price_ranges", {
  id: serial("id").primaryKey(),
  rangeName: text("range_name").notNull().unique(),
  minPrice: integer("min_price").notNull(),
  maxPrice: integer("max_price").notNull(),
  keywords: text("keywords").array(),
});

// Users table for authentication
export const users = pgTable("users", {
  id: serial("id").primaryKey(),
  email: text("email").notNull().unique(),
  password: text("password").notNull(),
  name: text("name"),
  role: text("role").notNull().default("user"), // 'user' or 'admin'
  createdAt: timestamp("created_at").default(sql`CURRENT_TIMESTAMP`).notNull(),
});

// Chat conversations for sommelier
export const conversations = pgTable("conversations", {
  id: serial("id").primaryKey(),
  userId: integer("user_id").references(() => users.id, { onDelete: "cascade" }),
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
export const insertOccasionTypeSchema = createInsertSchema(occasionTypes).omit({ id: true });
export const insertWineOccasionSchema = createInsertSchema(wineOccasions).omit({ id: true });
export const insertKeywordLibSchema = createInsertSchema(keywordLib).omit({ id: true });
export const insertTasteLevelSchema = createInsertSchema(tasteLevels).omit({ id: true });
export const insertPriceRangeSchema = createInsertSchema(priceRanges).omit({ id: true });
export const insertConversationSchema = createInsertSchema(conversations).omit({ id: true, createdAt: true });
export const insertMessageSchema = createInsertSchema(messages).omit({ id: true, createdAt: true });

// Types
export type Wine = typeof wines.$inferSelect;
export type InsertWine = z.infer<typeof insertWineSchema>;
export type OccasionType = typeof occasionTypes.$inferSelect;
export type InsertOccasionType = z.infer<typeof insertOccasionTypeSchema>;
export type WineOccasion = typeof wineOccasions.$inferSelect;
export type InsertWineOccasion = z.infer<typeof insertWineOccasionSchema>;
export type KeywordLib = typeof keywordLib.$inferSelect;
export type InsertKeywordLib = z.infer<typeof insertKeywordLibSchema>;
export type TasteLevel = typeof tasteLevels.$inferSelect;
export type InsertTasteLevel = z.infer<typeof insertTasteLevelSchema>;
export type PriceRange = typeof priceRanges.$inferSelect;
export type InsertPriceRange = z.infer<typeof insertPriceRangeSchema>;
export type Conversation = typeof conversations.$inferSelect;
export type InsertConversation = z.infer<typeof insertConversationSchema>;
export type Message = typeof messages.$inferSelect;
export type InsertMessage = z.infer<typeof insertMessageSchema>;

// Filter types for the UI
export const wineTypes = ["RED", "WHITE", "SPARKLING", "Rose", "Fortified"] as const;
export const priceRangeFilters = [
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

// User schemas
export const insertUserSchema = createInsertSchema(users).omit({ id: true, createdAt: true });
export const loginUserSchema = z.object({
  email: z.string().email(),
  password: z.string().min(6),
});
export const registerUserSchema = z.object({
  email: z.string().email(),
  password: z.string().min(6),
  name: z.string().optional(),
});

export type InsertUser = z.infer<typeof insertUserSchema>;
export type User = typeof users.$inferSelect;
export type SafeUser = Omit<User, "password">;
export type LoginUser = z.infer<typeof loginUserSchema>;
export type RegisterUser = z.infer<typeof registerUserSchema>;
