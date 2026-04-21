# 🍷 AI Wine Sommelier 개발 일지

> 본 문서는 프로젝트 시작부터 현재(2026년 4월)까지의 주요 개발 흐름을 시간순으로 정리한 기록입니다.

---

## 📋 프로젝트 개요

**AI Wine Sommelier**는 OpenAI 기반 대화형 와인 추천과 구조화된 필터 검색을 결합한 웹 애플리케이션입니다.

- **목표**: 와인 초보자부터 애호가까지 자연어 대화 또는 필터로 자신에게 맞는 와인을 찾을 수 있도록 돕는 서비스
- **디자인 컨셉**: Vivino의 미적 감각 + wine.com의 정보 구조
- **언어**: 한국어 UI (한/영 혼합 검색 지원)
- **데이터**: 와인 231종 (CSV 시딩)

### 기술 스택

| 레이어 | 기술 |
|--------|------|
| Frontend | React 18, TypeScript, Vite, Wouter, TanStack Query, shadcn/ui, Tailwind CSS |
| Backend | Express.js, TypeScript |
| Database | PostgreSQL + Drizzle ORM |
| AI | OpenAI API (Replit AI Integrations) |
| Auth | bcrypt + connect-pg-simple (PostgreSQL 세션) |
| Deployment | Replit Deployments |

---

## 🗓️ 개발 타임라인

### Phase 1: 초기 설계 및 기본 구조

**목표**: 프로젝트 뼈대 잡기

- 데이터 모델 설계 (`shared/schema.ts`)
  - `wines`, `occasions`, `conversations`, `messages`, `keywordLib`, `users` 테이블 정의
  - Drizzle-Zod로 frontend/backend 타입 일관성 확보
- CSV 파일에서 와인 231종 시딩
- Express + Vite 미들웨어 통합 (단일 포트 서비스)
- Wouter 기반 라우팅 (`/`, `/admin`, 404)

### Phase 2: 핵심 기능 구현

**목표**: 와인 검색 + AI 추천 MVP 완성

- 와인 목록/검색/필터 페이지 (메인)
- 카테고리 필터 (Red, White, Sparkling, Rosé, Fortified, Dessert)
- 상세 필터 (국가, 용도/상황, 가격대)
- AI 소믈리에 채팅 컴포넌트
  - **Server-Sent Events(SSE)** 기반 실시간 스트리밍 응답
  - 와인 DB 컨텍스트 주입(hallucination 방지)
- Vivino 풍 카드/타이포그래피 적용
- 다크/라이트 테마 토글

### Phase 3: 사용자 인증 시스템

**목표**: 회원가입/로그인으로 개인화 기반 마련

- DB 기반 커스텀 인증 구축
  - `users` 테이블 (email, password, name, role, createdAt)
  - bcrypt 암호화 (salt rounds: 10)
- API 엔드포인트
  - `POST /api/auth/register` — 회원가입 (이메일, 비밀번호 6자 이상, 이름 검증)
  - `POST /api/auth/login` — 로그인
  - `POST /api/auth/logout` — 로그아웃
  - `GET /api/auth/me` — 현재 사용자 확인
- PostgreSQL 백엔드 세션 (`connect-pg-simple`)
  - 7일 유지, httpOnly 쿠키
- 역할 기반 접근 제어 (`user` / `admin`)

### Phase 4: 관리자 기능

**목표**: 사용자 관리 도구 제공

- 관리자 페이지 (`/admin`)
- 사용자 목록 조회 (역할 배지 표시)
- 사용자 이름/역할 인라인 편집
- 사용자 삭제 (본인 삭제 방지)
- 비밀번호 초기화 기능
- **최초 가입자 자동 admin 부여** 정책

### Phase 5: 채팅 히스토리 차별화

**목표**: 게스트와 회원의 경험 분리

- **비로그인 사용자**
  - 브라우저 메모리(React state)에만 저장
  - 세션 종료 시 사라짐
  - 별도 엔드포인트 `/api/sommelier/chat/guest` (sanitized 히스토리)
- **로그인 사용자**
  - PostgreSQL DB 영구 저장
  - 대화 검색 기능
  - 이전 대화 불러오기

### Phase 6: UX 개선

**목표**: 사용성과 시각적 완성도 끌어올리기

- 히어로 배너 리디자인
- 추천(Trending) 와인 캐러셀
- 검색 디바운싱 (300ms, `searchInput`/`searchQuery` 상태 분리)
- 플로팅 AI 소믈리에 버튼 (펄스 애니메이션)
- 한국어 ↔ 영어 검색 매핑
  - 18개국 (예: "프랑스" ↔ "France")
  - 6개 와인 종류 (예: "레드" ↔ "Red")
- 사용자 드롭다운 메뉴 (이름/이메일, 비밀번호 변경, 관리자 페이지, 로그아웃)
- 관리자 비밀번호 초기화 다이얼로그

### Phase 7: 모바일 최적화

**목표**: iPad Safari를 포함한 모바일 환경 대응

- iPad Safari viewport 높이 이슈 해결
  - **`dvh` → `--vh` CSS 변수 → `-webkit-fill-available`** 폴백 체인
  - resize/scroll/focusin/focusout/orientationchange 이벤트로 `--vh` 동적 갱신
  - 100ms 디바운스 적용
- 모바일 채팅 오버레이
  - `fixed inset-0` → `fixed-full-height` CSS 클래스로 교체
  - Safari 동적 주소창에 따른 입력창 잘림 방지

### Phase 8: 프로덕션 배포 및 버그 수정

**목표**: 안정적인 배포 환경 구축

- Replit Deployments로 첫 배포
- **프로덕션 로그인 버그 발견**
  - 증상: 로그인 성공 메시지는 뜨지만 실제로 인증 안 됨
  - 원인: HTTPS 리버스 프록시 환경에서 secure 쿠키가 설정되지 않음
- **수정 사항** (`server/index.ts`)
  - `app.set("trust proxy", 1)` — Replit 프록시 신뢰
  - `cookie.sameSite: 'lax'` — 쿠키 전달 보장
  - 재배포 후 정상 동작 확인

---

## 🎯 주요 의사결정

### 1. 하이브리드 추천 시스템
**대화형 AI + 구조화된 필터**를 모두 제공.  
→ 와인을 잘 모르는 사용자는 채팅으로, 익숙한 사용자는 필터로 빠르게 탐색.

### 2. SSE 스트리밍
WebSocket 대신 **Server-Sent Events** 채택.  
→ 단방향 응답 스트리밍에 충분하며 인프라 단순.

### 3. 공유 스키마 (`shared/schema.ts`)
Drizzle + Zod로 타입을 한 곳에서 정의.  
→ 프론트와 백엔드 사이 타입 불일치 제거.

### 4. 와인 컨텍스트 주입
AI에게 실제 DB 와인 목록을 컨텍스트로 전달.  
→ 재고에 없는 와인을 추천하는 hallucination 방지.

### 5. 게스트/회원 채팅 차별화
게스트는 메모리, 회원은 DB.  
→ 회원가입 동기를 자연스럽게 부여하면서 진입장벽 최소화.

### 6. 커스텀 DB 인증
OAuth 대신 이메일/비밀번호 인증 직접 구현.  
→ 외부 의존성 최소화, 한국 사용자 친화적 가입 흐름.

---

## 🔧 기술적 챌린지 & 해결

| 문제 | 해결 |
|------|------|
| iPad Safari 뷰포트 높이 변동 | `dvh` + `--vh` CSS 변수 + `-webkit-fill-available` 폴백 |
| 모바일 채팅 입력창 잘림 | `fixed-full-height` 클래스로 동적 높이 적용 |
| 한국어 검색이 영어 데이터 매칭 실패 | `server/storage.ts`에 한↔영 매핑 추가 (18개국, 6종) |
| 프로덕션 로그인 후 세션 소실 | `trust proxy` + `sameSite: 'lax'` 설정 |
| AI 추천에 없는 와인 등장 | DB 와인 목록을 시스템 프롬프트에 주입 |

---

## 📈 향후 개선 아이디어

- [ ] 와인 즐겨찾기/위시리스트 기능
- [ ] 사용자 리뷰/평점 시스템
- [ ] 음식 페어링 추천 (음식 사진 업로드 → 와인 추천)
- [ ] 음성 채팅 인터페이스 (Replit 음성 통합 활용)
- [ ] 와인 장바구니 및 결제 연동
- [ ] 다국어 지원 (영어, 일본어)
- [ ] 관리자용 와인 CRUD UI

---

## 📝 회고

본 프로젝트는 **단순한 와인 카탈로그를 넘어, 자연어로 대화하며 추천을 받는 새로운 형태의 탐색 경험**을 만들어 보는 시도였습니다.

특히 다음 부분에서 의미 있는 진전을 만들 수 있었습니다:

- **하이브리드 UX**: 자연어 대화와 구조화된 필터의 공존
- **모바일 우선**: iPad/iPhone Safari까지 고려한 viewport 처리
- **신뢰할 수 있는 AI**: DB 컨텍스트 주입으로 환각 최소화
- **운영 안정성**: 배포 환경의 세션 이슈를 신속히 발견·수정

앞으로는 사용자 데이터가 쌓이면서 **개인화 추천 정확도 개선**과 **소셜 기능**으로 확장해 나갈 수 있을 것입니다.
