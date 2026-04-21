# 🏗️ 시스템 아키텍처

## 전체 구조

```
┌─────────────────────────────────────────────────────────┐
│                     Browser (Client)                     │
│  React 18 + TypeScript + Vite + Wouter + TanStack Query │
│              shadcn/ui + Tailwind CSS                    │
└────────────────────┬────────────────────────────────────┘
                     │ HTTP / SSE
┌────────────────────▼────────────────────────────────────┐
│                  Express.js Server                       │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  │
│  │  Auth Routes │  │  Wine Routes │  │ Sommelier AI │  │
│  └──────────────┘  └──────────────┘  └──────┬───────┘  │
│  ┌──────────────────────────────────────────▼────────┐ │
│  │              Storage Interface (IStorage)          │ │
│  └──────────────────────┬─────────────────────────────┘ │
└─────────────────────────┼────────────────────────────────┘
              ┌───────────┴───────────┐
              │                       │
    ┌─────────▼──────────┐  ┌────────▼─────────┐
    │   PostgreSQL DB     │  │   OpenAI API     │
    │  (wines, users,     │  │ (AI Integrations) │
    │   conversations,    │  │                  │
    │   sessions, ...)    │  │                  │
    └─────────────────────┘  └──────────────────┘
```

## 디렉토리 구조

```
.
├── client/                        # 프론트엔드
│   ├── src/
│   │   ├── pages/                 # 라우트별 페이지
│   │   │   ├── home.tsx           # 메인 페이지
│   │   │   ├── admin.tsx          # 관리자 페이지
│   │   │   └── not-found.tsx
│   │   ├── components/            # 재사용 컴포넌트
│   │   │   ├── sommelier-chat.tsx # AI 채팅 패널
│   │   │   ├── auth-modal.tsx     # 로그인/회원가입 모달
│   │   │   ├── wine-card.tsx
│   │   │   ├── wine-filters.tsx
│   │   │   └── ui/                # shadcn/ui 컴포넌트
│   │   ├── hooks/                 # 커스텀 훅
│   │   ├── lib/                   # 유틸리티
│   │   ├── App.tsx                # 라우트 정의
│   │   └── index.css              # 전역 스타일 + 테마 변수
│   └── index.html
│
├── server/                        # 백엔드
│   ├── index.ts                   # Express 진입점, 세션 설정
│   ├── routes.ts                  # API 라우트 등록
│   ├── storage.ts                 # IStorage 구현 (CRUD)
│   ├── auth.ts                    # 인증 미들웨어/유틸
│   ├── vite.ts                    # Vite 미들웨어 통합
│   └── replit_integrations/       # Replit 통합 유틸
│
├── shared/
│   └── schema.ts                  # Drizzle 스키마 + Zod 타입
│
├── docs/                          # 프로젝트 문서
├── attached_assets/               # 시딩용 CSV, 이미지 등
├── drizzle.config.ts              # Drizzle 설정
├── vite.config.ts
└── package.json
```

## 레이어별 책임

### Frontend (client/)
- 사용자 인터페이스 렌더링
- TanStack Query로 서버 상태 관리
- Wouter로 클라이언트 사이드 라우팅
- 폼 검증 (react-hook-form + zod)
- 다크/라이트 테마 토글

### Backend (server/)
- REST API 제공
- SSE 기반 AI 응답 스트리밍
- 세션 기반 인증 (PostgreSQL 세션 스토어)
- Drizzle ORM으로 DB 접근
- OpenAI API 호출

### Shared (shared/)
- 데이터 스키마 단일 진실 소스
- Drizzle-Zod 통합으로 frontend/backend 타입 일관성

## 데이터 흐름

### AI 채팅 흐름 (회원)
```
1. 사용자가 채팅 입력
   ↓
2. POST /api/sommelier/chat (with sessionId)
   ↓
3. 서버: 사용자 메시지 DB 저장
   ↓
4. 서버: 와인 DB 컨텍스트 + 대화 히스토리 → OpenAI
   ↓
5. OpenAI 스트리밍 응답 → SSE로 클라이언트 전달
   ↓
6. 서버: 완성된 응답 DB 저장
   ↓
7. 클라이언트: 실시간으로 텍스트 렌더링
```

### 인증 흐름
```
1. POST /api/auth/login
   ↓
2. bcrypt.compare로 비밀번호 검증
   ↓
3. req.session.userId 설정
   ↓
4. PostgreSQL 세션 테이블에 저장
   ↓
5. httpOnly + secure + sameSite=lax 쿠키 발급
   ↓
6. 이후 요청에서 쿠키 → 세션 조회 → req.session.userId
```

## 보안 고려사항

- **비밀번호**: bcrypt (salt rounds 10)
- **세션**: httpOnly, secure (production), sameSite=lax
- **HTTPS**: Replit 자동 처리, `trust proxy` 설정 필수
- **세션 시크릿**: `SESSION_SECRET` 환경변수 (production 필수)
- **권한 검증**: 미들웨어 레벨에서 admin 역할 확인

## 성능 최적화

- **검색 디바운싱**: 300ms (`searchInput`/`searchQuery` 분리)
- **무한 스크롤**: 와인 목록 페이지네이션
- **TanStack Query 캐시**: 동일 쿼리 자동 캐시
- **SSE 스트리밍**: 첫 토큰까지의 체감 지연 최소화
