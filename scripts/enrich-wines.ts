/**
 * 와인 강화 데이터 생성 스크립트
 *
 * 사용법:
 *   railway run --service wine-sommelier npx tsx scripts/enrich-wines.ts
 *
 * 동작:
 *   - DB에서 enriched_at이 null인 와인만 처리 (중복 방지)
 *   - GPT-4o-mini로 mood_tags, scene_tags, emotion_story, sales_pitch, pairing_detail 생성
 *   - 3초 간격으로 API 호출 (Rate limit 방지)
 *   - 실패한 와인은 건너뛰고 계속 진행
 */

import "dotenv/config";
import { drizzle } from "drizzle-orm/node-postgres";
import { Pool } from "pg";
import { isNull } from "drizzle-orm";
import OpenAI from "openai";
import { wines } from "../shared/schema";
import { sql } from "drizzle-orm";

const pool = new Pool({ connectionString: process.env.DATABASE_URL });
const db = drizzle(pool);
const openai = new OpenAI({ apiKey: process.env.OPENAI_API_KEY });

// 생성할 강화 데이터 타입
interface EnrichmentData {
  mood_tags: string[];
  scene_tags: string[];
  emotion_story: string;
  sales_pitch: string;
  pairing_detail: string;
}

// GPT-4o-mini로 강화 데이터 생성
async function generateEnrichment(wine: typeof wines.$inferSelect): Promise<EnrichmentData | null> {
  const prompt = `당신은 와인 마케팅 전문가입니다. 아래 와인 정보를 보고 감성 마케팅 데이터를 JSON으로 생성하세요.

[와인 정보]
이름: ${wine.nameKr} (${wine.nameEn || ""})
타입: ${wine.type || "미상"} / 국가: ${wine.nation || "미상"} / 품종: ${wine.varieties || "미상"}
단맛:${wine.sweet || 0}/산미:${wine.acidity || 0}/바디:${wine.body || 0}/탄닌:${wine.tannin || 0} (1-5)
가격: ${wine.price ? wine.price.toLocaleString() + "원" : "미상"}
기존 설명: ${wine.description || wine.summary || wine.tastingNote || "없음"}

[출력 형식 — 반드시 JSON만 출력]
{
  "mood_tags": ["감성1", "감성2", "감성3"],
  "scene_tags": ["상황1", "상황2", "상황3"],
  "emotion_story": "3단계 공식으로 작성: [이 와인의 구체적 맛·향·질감] + [첫 모금에 느껴지는 감각 묘사] + [그 감각이 어떤 상황/감정에 연결되는지]. 2~3문장.",
  "sales_pitch": "소매상이 소비자에게 직접 말하듯 1~2문장. '이 와인은 ~~~한 특성 덕분에 ~~~하실 때 딱 맞습니다.' 형식.",
  "pairing_detail": "구체적인 음식 3~5가지. 예: 연어구이, 브리 치즈, 파스타(크림소스)"
}

[mood_tags 예시]: "위로", "설렘", "차분함", "활기찬", "로맨틱", "사색적", "축제", "편안함"
[scene_tags 예시]: "혼술", "데이트", "비즈니스디너", "야외피크닉", "홈파티", "기념일", "친구모임", "비오는날저녁"

[금지 표현]
- emotion_story에 "저절로", "자연스럽게", "잘 어울립니다"를 이유 없이 단독 사용 금지
- 구체적인 맛/향/질감 단어 없이 감성 결론만 쓰지 말 것`;

  try {
    const response = await openai.chat.completions.create({
      model: "gpt-4o-mini",
      messages: [{ role: "user", content: prompt }],
      response_format: { type: "json_object" },
      max_tokens: 600,
      temperature: 0.7,
    });

    const content = response.choices[0]?.message?.content;
    if (!content) return null;

    const data = JSON.parse(content) as EnrichmentData;
    return data;
  } catch (err) {
    console.error(`  ❌ GPT 오류:`, err);
    return null;
  }
}

// 메인 실행
async function main() {
  console.log("🍷 와인 강화 데이터 생성 시작\n");

  // enriched_at이 null인 와인만 조회
  const wineList = await db
    .select()
    .from(wines)
    .where(isNull(wines.enrichedAt));

  console.log(`📋 처리할 와인: ${wineList.length}개\n`);

  let success = 0;
  let failed = 0;

  for (let i = 0; i < wineList.length; i++) {
    const wine = wineList[i];
    const progress = `[${i + 1}/${wineList.length}]`;

    console.log(`${progress} ${wine.nameKr} (${wine.id})`);

    const enrichment = await generateEnrichment(wine);

    if (!enrichment) {
      console.log(`  ⚠️  건너뜀\n`);
      failed++;
      continue;
    }

    // DB에 저장
    await db
      .update(wines)
      .set({
        moodTags: enrichment.mood_tags,
        sceneTags: enrichment.scene_tags,
        emotionStory: enrichment.emotion_story,
        salesPitch: enrichment.sales_pitch,
        pairingDetail: enrichment.pairing_detail,
        enrichedAt: sql`CURRENT_TIMESTAMP`,
      })
      .where(sql`id = ${wine.id}`);

    console.log(`  ✅ mood: [${enrichment.mood_tags.join(", ")}]`);
    console.log(`     scene: [${enrichment.scene_tags.join(", ")}]`);
    console.log(`     story: ${enrichment.emotion_story.slice(0, 60)}...`);
    console.log();

    success++;

    // 마지막이 아니면 3초 대기
    if (i < wineList.length - 1) {
      await new Promise((r) => setTimeout(r, 3000));
    }
  }

  console.log("─".repeat(50));
  console.log(`✅ 완료: ${success}개 성공 / ❌ ${failed}개 실패`);
  console.log(`💰 예상 비용: 약 ₩${Math.round(success * 2)} (GPT-4o-mini 기준)`);

  await pool.end();
}

main().catch((err) => {
  console.error("실행 오류:", err);
  process.exit(1);
});
