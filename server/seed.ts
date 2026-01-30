import { parse } from "csv-parse/sync";
import fs from "fs";
import path from "path";
import { db } from "./db";
import { wines, type InsertWine } from "@shared/schema";
import { sql } from "drizzle-orm";

async function seedDatabase() {
  console.log("Starting database seeding...");

  // Check if wines already exist
  const existingCount = await db.select({ count: sql<number>`count(*)` }).from(wines);
  if (Number(existingCount[0]?.count) > 0) {
    console.log(`Database already has ${existingCount[0].count} wines. Skipping seed.`);
    return;
  }

  // Read CSV file
  const csvPath = path.join(process.cwd(), "attached_assets", "WineList_1769812439741.csv");
  
  if (!fs.existsSync(csvPath)) {
    console.error("CSV file not found:", csvPath);
    return;
  }

  const csvContent = fs.readFileSync(csvPath, "utf-8");
  
  // Parse CSV
  const records = parse(csvContent, {
    columns: true,
    skip_empty_lines: true,
    bom: true,
    relax_column_count: true,
  });

  console.log(`Parsed ${records.length} records from CSV`);

  const wineInserts: InsertWine[] = [];
  const seenIds = new Set<string>();

  for (const record of records) {
    const id = record.id?.trim();
    if (!id || seenIds.has(id)) continue;
    seenIds.add(id);

    const parseNum = (val: string | undefined): number | null => {
      if (!val || val.trim() === "") return null;
      const num = parseFloat(val);
      return isNaN(num) ? null : num;
    };

    const parsePrice = (val: string | undefined): number | null => {
      if (!val || val.trim() === "") return null;
      const cleaned = val.replace(/[^0-9]/g, "");
      const num = parseInt(cleaned);
      return isNaN(num) ? null : num;
    };

    try {
      wineInserts.push({
        id,
        nameEn: record["name(EN)"]?.trim() || null,
        nameKr: record["name(KR)"]?.trim() || id,
        producer: record.producer?.trim() || null,
        nation: record.nation?.trim() || null,
        region: record.local?.trim() || null,
        varieties: record.varieties?.trim() || null,
        type: record.type?.trim()?.toUpperCase() || null,
        use: record.use?.trim() || null,
        abv: parseNum(record.abv),
        sweet: parseNum(record.sweet),
        acidity: parseNum(record.acidity),
        body: parseNum(record.body),
        tannin: parseNum(record.tannin),
        price: parsePrice(record.price),
        year: record.year?.trim() || null,
        ml: parsePrice(record.ml),
        stock: parsePrice(record["in stock(재고수량)"]),
        vivinoRating: parseNum(record["Vivino 평점"]),
        summary: record["한줄요약"]?.trim() || null,
        notes: record["참고사항"]?.trim() || null,
        description: record["상세설명"]?.trim() || null,
        tastingNote: record["테이스팅 노트"]?.trim() || null,
        pairing: record["페어링 정보"]?.trim() || null,
        occasionTags: record.Occasion_Tags?.trim() || record.occasion?.trim() || null,
        sampleGroup: record.sample_group?.trim() || null,
      });
    } catch (e) {
      console.error(`Error parsing record ${id}:`, e);
    }
  }

  console.log(`Prepared ${wineInserts.length} wine records for insertion`);

  // Insert in batches
  const batchSize = 50;
  for (let i = 0; i < wineInserts.length; i += batchSize) {
    const batch = wineInserts.slice(i, i + batchSize);
    try {
      await db.insert(wines).values(batch).onConflictDoNothing();
      console.log(`Inserted batch ${Math.floor(i / batchSize) + 1}/${Math.ceil(wineInserts.length / batchSize)}`);
    } catch (error) {
      console.error(`Error inserting batch starting at ${i}:`, error);
    }
  }

  // Verify
  const finalCount = await db.select({ count: sql<number>`count(*)` }).from(wines);
  console.log(`Seeding complete. Total wines in database: ${finalCount[0].count}`);
}

seedDatabase()
  .then(() => {
    console.log("Seed script finished");
    process.exit(0);
  })
  .catch((error) => {
    console.error("Seed script failed:", error);
    process.exit(1);
  });
