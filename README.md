# AI Wine Sommelier 🍷

OpenAI 기반 대화형 와인 추천 + 구조화 필터 검색 웹앱 (한국어 UI)

- **라이브 서비스**: https://wine-sommelier-production.up.railway.app
- **GitHub**: https://github.com/thelyver/Wine-Sommelier-AI

---

## 기술 스택

| 영역 | 기술 |
|------|------|
| Frontend | React 18, TypeScript, Vite, Tailwind CSS, shadcn/ui |
| Backend | Express.js, TypeScript |
| Database | PostgreSQL, Drizzle ORM |
| AI | OpenAI API |
| 배포 | Railway (GitHub 자동 배포) |

---

## 로컬 개발 환경 세팅

### 사전 요구사항

- Node.js v22 이상
- PostgreSQL (로컬 설치) 또는 Railway DB 연결

### 1. 저장소 클론

```bash
git clone https://github.com/thelyver/Wine-Sommelier-AI.git
cd Wine-Sommelier-AI
```

### 2. 패키지 설치

```bash
npm install
```

### 3. 환경변수 설정

```bash
cp .env.example .env
```

`.env` 파일을 열고 아래 값을 채워주세요:

| 변수 | 설명 | 예시 |
|------|------|------|
| `DATABASE_URL` | PostgreSQL 연결 문자열 | `postgresql://postgres:pw@localhost:5432/wine_sommelier` |
| `OPENAI_API_KEY` | OpenAI API 키 | `sk-proj-...` |
| `SESSION_SECRET` | 세션 암호화 키 | `openssl rand -hex 32` 으로 생성 |

> **Railway DB 사용 시**: Railway 대시보드 → Postgres 서비스 → Variables → `DATABASE_PUBLIC_URL` 값을 `DATABASE_URL`에 입력

### 4. 데이터베이스 테이블 생성

```bash
npm run db:push
```

### 5. 와인 데이터 임포트

`backup_export/database_backup.sql` 파일에 와인 231개 데이터가 있습니다.

```bash
psql $DATABASE_URL -f backup_export/database_backup.sql
```

> 테이블 생성 오류가 나도 무시하세요 (이미 생성된 경우). 데이터(COPY)만 들어가면 됩니다.

### 6. 개발 서버 실행

```bash
npm run dev
```

브라우저에서 `http://localhost:5000` 접속

---

## 프로젝트 구조

```
├── client/               # React 프론트엔드
│   └── src/
│       ├── pages/        # 페이지 컴포넌트
│       ├── components/   # 공통 컴포넌트
│       ├── hooks/        # 커스텀 훅
│       └── lib/          # 유틸리티
├── server/               # Express 백엔드
│   ├── index.ts          # 서버 진입점
│   ├── routes.ts         # API 라우트
│   ├── storage.ts        # DB 쿼리 레이어
│   └── db.ts             # DB 연결
├── shared/
│   └── schema.ts         # Drizzle DB 스키마 (프론트/백 공유)
├── backup_export/        # DB 백업 데이터
└── railway.json          # Railway 배포 설정
```

---

## 주요 명령어

```bash
npm run dev        # 개발 서버 실행 (localhost:5000)
npm run build      # 프로덕션 빌드
npm run start      # 프로덕션 서버 실행
npm run db:push    # DB 스키마 동기화
```

---

## 배포 (Railway)

`main` 브랜치에 push하면 Railway가 자동으로 재배포합니다.

```bash
git add .
git commit -m "변경 내용"
git push
```

Railway 대시보드: https://railway.com/project/d6441310-4295-4053-815c-b81a2fa12b01

---

## 환경변수 (Railway 프로덕션)

| 변수 | 설명 |
|------|------|
| `DATABASE_URL` | Railway Postgres 내부 연결 (`${{Postgres.DATABASE_URL}}`) |
| `OPENAI_API_KEY` | OpenAI API 키 |
| `SESSION_SECRET` | 세션 암호화 키 |
| `NODE_ENV` | `production` |
