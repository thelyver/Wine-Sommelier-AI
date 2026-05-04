# joomoon.ai 플랫폼 PRD
**Product Requirements Document**

| 항목 | 내용 |
|------|------|
| 버전 | v0.3 |
| 작성일 | 2026-05-04 |
| 상태 | 초안 — AI 소믈리에 기술 설계 확정 |
| 이전 버전 | [v0.2](./PRD_v0.2.md) |

> **v0.2 → v0.3 변경 요약**
> - AI 소믈리에 기술 아키텍처 확정
> - 와인 강화 데이터 파이프라인 설계 추가
> - pgvector 도입 시점 및 전환 전략 확정
> - 데이터 스키마 상세화

---

## 변경/추가된 내용만 기록 (나머지는 v0.2 동일)

---

## A. AI 소믈리에 기술 아키텍처 (확정)

### 확정된 두 가지 결정

```
결정 1. pgvector는 와인 1,000개 초과 시점에 도입
        → 지금은 하이브리드 방식으로 충분
        → 전환 리스크 없음 (동일 PostgreSQL에 추가만 하면 됨)

결정 2. 공급자가 와인 등록 시 GPT가 강화 데이터 자동 생성
        → 매번 생성 아닌 1회 생성 후 DB 저장
        → AI 소믈리에가 이 데이터를 활용
```

---

### AI 소믈리에 전체 흐름

```
[Phase 1 ~ Phase 2]  와인 1,000개 미만

사용자 질문
    │
    ▼
① GPT-4o-mini — 의도 분석 (₩5/건)
    "비 오는 날 혼자 위로받고 싶어"
    → mood: [위로, 차분함]
    → scene: [혼술, 실내]
    → type: 제한 없음
    │
    ▼
② DB 검색 — 강화 데이터 태그 기반
    scene_tags에 "혼술" OR "실내" 포함
    → 관련 와인 20개 추출
    │
    ▼
③ GPT-4o — 스토리텔링 추천 (₩31/건)
    20개 와인 + emotion_story 데이터 활용
    → 문학적·감성적 추천 생성
    │
    ▼
총 비용: 메시지당 약 ₩36


[Phase 3]  와인 1,000개 초과 시 pgvector 추가

② 단계만 변경:
DB 태그 검색 → pgvector 의미 유사도 검색
(나머지 ①③ 동일, 코드 변경 최소화)
```

---

### 메시지당 비용 비교

| 방식 | 품질 | 메시지당 비용 | 월 비용 (100명/일) |
|------|------|-------------|-----------------|
| 현재 (키워드 30개) | 🟡 보통 | ₩31 | ₩28만 |
| 하이브리드 (확정안) | ✅ 높음 | ₩36 | ₩32만 |
| pgvector 추가 후 | ✅ 높음 | ₩36 | ₩32만 (동일) |

**품질은 크게 향상되고 비용은 현재와 거의 동일**

---

## B. 와인 강화 데이터 파이프라인 (신규)

### 개념

```
공급자가 와인 등록
        ↓
기본 정보 입력
(이름, 타입, 가격, 산미/바디/탄닌 등)
        ↓
GPT-4o-mini가 자동으로 강화 데이터 생성
비용: 와인 1개당 약 ₩2
        ↓
DB에 저장 (이후 비용 없음)
        ↓
AI 소믈리에가 활용
```

### 강화 데이터 항목

```ts
// wines 테이블에 추가될 컬럼들

mood_tags: string[]
// 예: ["로맨틱", "위로", "활기찬", "차분한", "축제"]

scene_tags: string[]
// 예: ["데이트", "혼술", "비즈니스디너", "야외피크닉", "홈파티"]

emotion_story: text
// 예: "비가 내리는 저녁, 창가에 앉아 혼자 마시기에
//      딱 맞는 온도의 와인입니다. 첫 잔의 체리향이
//      조용히 위로를 건넵니다."

sales_pitch: text
// 예: "손님께 이렇게 설명하세요:
//      피노누아 특유의 섬세함 덕분에 대화 흐름을
//      깨지 않아요. 첫 잔부터 반응이 좋습니다."

pairing_detail: text
// 예: "파스타(토마토/크림), 연어구이, 브리 치즈,
//      가벼운 스테이크와 특히 잘 어울립니다."

is_sample: boolean
// 가짜 데이터 여부 (true = 테스트용)
```

### GPT 강화 생성 프롬프트 (초안)

```
[시스템]
당신은 와인 전문가입니다.
아래 와인 정보를 보고 다음 항목을 JSON으로 생성하세요.

[입력: 와인 기본 정보]
이름: {name_kr}
타입: {type} / 국가: {nation} / 품종: {varieties}
단맛:{sweet}/산미:{acidity}/바디:{body}/탄닌:{tannin} (1-5)
가격: {price}원
기존 설명: {description}

[출력 형식]
{
  "mood_tags": ["감성1", "감성2", "감성3"],
  "scene_tags": ["상황1", "상황2", "상황3"],
  "emotion_story": "2~3문장의 감성적 상황 묘사",
  "sales_pitch": "소매상이 소비자에게 설명할 멘트",
  "pairing_detail": "구체적인 음식 페어링"
}
```

### 강화 데이터 생성 시점

| 시점 | 설명 |
|------|------|
| 공급자 신규 등록 | 등록 즉시 자동 생성 |
| 관리자 직접 등록 | 등록 즉시 자동 생성 |
| 기존 데이터 일괄 처리 | 1회성 배치 스크립트 실행 |
| 와인 정보 수정 시 | 재생성 여부 선택 가능 |

### 기존 231개 일괄 처리 비용

```
231개 × GPT-4o-mini × 약 500 토큰 = 약 ₩50 (1회)
500개 기준 = 약 ₩100 (1회)
```

---

## C. pgvector 도입 전략 (확정)

### 도입 시점
- **트리거**: 와인 데이터 1,000개 초과
- **예상 시점**: Phase 3 (공급자 다수 입점 후)

### 전환 방식 (리스크 없음)

```
Step 1. Railway PostgreSQL에 pgvector 확장 설치
        명령어: CREATE EXTENSION vector;
        소요 시간: 5분

Step 2. wines 테이블에 벡터 컬럼 추가
        ALTER TABLE wines ADD COLUMN embedding vector(1536);
        기존 데이터 변경 없음

Step 3. 기존 와인 임베딩 생성 (1회)
        emotion_story + tasting_note → OpenAI Embedding API
        비용: 1,000개 기준 약 ₩150

Step 4. 검색 로직 전환
        기존 태그 검색 → 벡터 유사도 검색
        두 방식 동시 운영 → 비교 → 전환

Step 5. 검증 완료 후 기존 방식 제거
```

### 전환 후 달라지는 것

```
Before (태그 기반):
"비 오는 날 위로" → scene_tags 에서 "혼술" 찾기

After (벡터 기반):
"비 오는 날 위로" → 의미 벡터 → emotion_story 유사도 검색
→ 더 정확하고 다양한 결과
```

---

## D. 데이터 스키마 업데이트 계획

### wines 테이블 최종 목표 구조

```ts
export const wines = pgTable("wines", {
  // 기존 컬럼 (변경 없음)
  id, nameEn, nameKr, producer, nation, region,
  varieties, type, use, abv,
  sweet, acidity, body, tannin,
  price, year, ml, stock,
  vivinoRating, summary, notes,
  description, tastingNote, pairing,

  // Phase 1 추가
  imageUrl: text("image_url"),              // 와인 이미지
  status: text("status").default("active"), // 판매중/품절/단종
  isSample: boolean("is_sample").default(false), // 테스트 데이터 여부

  // Phase 2 추가 (강화 데이터 파이프라인)
  supplierId: integer("supplier_id"),       // 공급자 연결
  moodTags: text("mood_tags").array(),      // ["로맨틱", "위로"]
  sceneTags: text("scene_tags").array(),    // ["혼술", "데이트"]
  emotionStory: text("emotion_story"),      // 감성 상황 묘사
  salesPitch: text("sales_pitch"),          // 영업 멘트
  pairingDetail: text("pairing_detail"),    // 상세 페어링
  enrichedAt: timestamp("enriched_at"),     // 강화 데이터 생성 시각

  // Phase 3 추가 (pgvector)
  // embedding: vector("embedding", { dimensions: 1536 })
});
```

---

## E. 이슈 연결

| 이슈 | 연결 내용 |
|------|-----------|
| [#11](https://github.com/thelyver/Wine-Sommelier-AI/issues/11) | 하이브리드 방식 + 강화 데이터 활용 추천 |
| [#13](https://github.com/thelyver/Wine-Sommelier-AI/issues/13) | 공급자 등록 시 강화 데이터 자동 생성 파이프라인 포함 |
| [#4](https://github.com/thelyver/Wine-Sommelier-AI/issues/4) | 어드민 와인 등록 시도 동일 파이프라인 적용 |
| 신규 | 기존 231개 와인 일괄 강화 처리 스크립트 |

---

## 변경 이력

| 버전 | 날짜 | 변경 내용 |
|------|------|-----------|
| v0.1 | 2026-05-04 | 초안 — 비전, 사용자, 기능 로드맵 |
| v0.2 | 2026-05-04 | 브랜드명 확정, 결정사항 7개 반영 |
| v0.3 | 2026-05-04 | AI 기술 아키텍처 확정, 강화 데이터 파이프라인 설계 |
