# 🚀 배포 가이드

## Replit Deployments

본 프로젝트는 **Replit Autoscale Deployment**로 배포됩니다.

### 배포 방법

1. Replit 워크스페이스 우상단 **Publish** 버튼 클릭
2. 빌드 명령: `npm run build`
3. 시작 명령: `npm start`
4. 도메인 설정: `<프로젝트명>.replit.app` (또는 커스텀 도메인)

### 필수 환경변수 (Secrets)

| 변수 | 설명 |
|------|------|
| `DATABASE_URL` | PostgreSQL 연결 문자열 |
| `SESSION_SECRET` | 세션 암호화 키 (production 필수) |
| `AI_INTEGRATIONS_OPENAI_API_KEY` | OpenAI API 키 (Replit AI Integrations 자동 발급) |
| `AI_INTEGRATIONS_OPENAI_BASE_URL` | OpenAI Base URL (Replit AI Integrations 자동 발급) |
| `NODE_ENV` | `production` |

### 프로덕션 세션 설정

`server/index.ts`에서 다음 설정이 적용되어 있어야 정상 작동:

```ts
if (process.env.NODE_ENV === "production") {
  app.set("trust proxy", 1);
}

app.use(session({
  cookie: {
    secure: process.env.NODE_ENV === "production",
    httpOnly: true,
    sameSite: "lax",
    maxAge: 7 * 24 * 60 * 60 * 1000,
  },
  // ...
}));
```

> ⚠️ `trust proxy` 설정이 빠지면 HTTPS 환경에서 secure 쿠키가 발급되지 않아 로그인이 실패합니다.

### 배포 후 체크리스트

- [ ] 메인 페이지 정상 로드
- [ ] 와인 검색/필터 작동
- [ ] 회원가입/로그인 정상 (쿠키 발급 확인)
- [ ] AI 채팅 스트리밍 응답 확인
- [ ] 관리자 페이지 접근 권한 확인
- [ ] 모바일 (iPad Safari) viewport 확인

## 로컬 개발 환경

### 사전 준비
- Node.js 20+
- PostgreSQL DB

### 설치 및 실행
```bash
npm install
cp .env.example .env  # 환경변수 설정
npm run db:push       # DB 스키마 적용
npm run dev           # 개발 서버 (5000번 포트)
```

### `.env` 예시
```env
DATABASE_URL=postgres://user:pass@localhost:5432/wine_sommelier
SESSION_SECRET=your-secret-here
AI_INTEGRATIONS_OPENAI_API_KEY=sk-...
AI_INTEGRATIONS_OPENAI_BASE_URL=https://api.openai.com/v1
NODE_ENV=development
```

## 데이터베이스 백업

### 수동 백업
```bash
pg_dump $DATABASE_URL > backup_$(date +%Y%m%d).sql
```

### 복원
```bash
psql <target-database-url> < backup.sql
```

## 모니터링

### 로그 확인
- Replit Deployments 탭의 **Logs** 메뉴에서 실시간 로그 확인
- 워크플로우 콘솔에서 개발 환경 로그 확인

### 주요 모니터링 지표
- 응답 시간 (특히 AI 채팅 첫 응답)
- 5xx 에러율
- DB 커넥션 풀 사용률
- OpenAI API 사용량 / 비용

## 롤백

문제 발생 시 Replit의 **Checkpoints**를 활용해 이전 상태로 롤백 가능:
1. 좌측 사이드바의 체크포인트 메뉴 열기
2. 정상 동작하던 시점의 체크포인트 선택
3. **Restore** 클릭
4. 재배포
