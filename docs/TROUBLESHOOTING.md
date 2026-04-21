# 🔧 문제 해결 기록

이 문서는 개발 과정에서 만난 주요 이슈와 해결 방법을 모아둡니다.

---

## 🔐 프로덕션 로그인 후 인증되지 않는 문제

### 증상
- 배포 환경에서 로그인 API는 200 응답
- 그러나 이후 페이지에서 로그아웃 상태로 보임
- 개발 환경(`localhost`)에서는 정상

### 원인
Replit은 HTTPS 리버스 프록시 뒤에서 앱을 서비스. Express는 기본적으로 프록시를 신뢰하지 않아:
1. `req.secure`가 `false`로 인식
2. `cookie.secure: true` 설정 시 쿠키가 발급되지 않음
3. 결과적으로 세션 ID가 브라우저에 저장 안 됨

### 해결
`server/index.ts`에서:
```ts
if (process.env.NODE_ENV === "production") {
  app.set("trust proxy", 1);
}

app.use(session({
  cookie: {
    secure: process.env.NODE_ENV === "production",
    httpOnly: true,
    sameSite: "lax",  // 추가
    maxAge: 7 * 24 * 60 * 60 * 1000,
  },
}));
```

### 교훈
- 리버스 프록시 환경에서는 항상 `trust proxy` 설정 필요
- `sameSite` 명시적으로 지정하는 것이 안전

---

## 📱 iPad Safari 채팅창 입력란이 잘리는 문제

### 증상
- iPad Safari에서 모바일 채팅 오버레이를 열면 입력창이 화면 밖으로 잘림
- Safari의 동적 주소창 표시/숨김에 따라 viewport 높이가 변동

### 원인
- `100vh`는 Safari에서 주소창이 보일 때도 전체 화면 높이를 반환
- `fixed inset-0` 사용 시 입력창이 visible viewport를 벗어남

### 해결
1. **CSS 폴백 체인** (`client/src/index.css`)
   ```css
   .fixed-full-height {
     height: 100vh;                    /* fallback */
     height: -webkit-fill-available;   /* iOS Safari */
     height: calc(var(--vh, 1vh) * 100); /* JS 동적 갱신 */
     height: 100dvh;                   /* 최신 표준 */
   }
   ```

2. **JS 이벤트 리스너로 `--vh` 동적 갱신**
   - `resize`, `scroll`, `focusin`, `focusout`, `orientationchange` 이벤트
   - 100ms 디바운스 적용

3. **`home.tsx`에서 클래스 적용**
   ```tsx
   <div className="fixed-full-height ...">
   ```

---

## 🔍 한국어 검색이 와인 데이터와 매칭 안 되는 문제

### 증상
- "프랑스" 검색 시 결과 없음
- 데이터는 영어("France")로 저장됨

### 해결
`server/storage.ts`에 한↔영 매핑 추가:
```ts
const NATION_MAP: Record<string, string> = {
  "프랑스": "France",
  "이탈리아": "Italy",
  // ... 18개국
};

const TYPE_MAP: Record<string, string> = {
  "레드": "Red",
  "화이트": "White",
  // ... 6종
};
```

검색 시 입력어를 매핑된 영어로 변환하여 ILIKE 검색 수행.

---

## 🤖 AI가 DB에 없는 와인을 추천하는 문제

### 증상
- AI 소믈리에가 실제 재고에 없는 와인을 추천 (hallucination)

### 해결
AI 호출 시 시스템 프롬프트에 **현재 와인 DB 목록을 컨텍스트로 주입**:
```ts
const wines = await storage.getAllWines();
const systemPrompt = `
당신은 와인 소믈리에입니다.
다음은 현재 추천 가능한 와인 목록입니다:
${wines.map(w => `- ${w.name} (${w.type}, ${w.nation})`).join('\n')}

이 목록 안에서만 추천하세요.
`;
```

---

## 💬 게스트 채팅 히스토리 처리

### 결정 사항
- **로그인 사용자**: DB에 저장 → `/api/sommelier/chat`
- **비로그인 사용자**: 클라이언트 메모리에만 보관 → `/api/sommelier/chat/guest`

### 구현 포인트
- 게스트 엔드포인트는 `history` 배열을 요청 본문으로 받음
- 서버에서 sanitize 후 OpenAI에 전달
- 응답은 SSE 스트리밍, DB 저장 없음

---

## 🐛 일반 디버깅 팁

### 세션 디버깅
```bash
# DB에서 세션 직접 확인
psql $DATABASE_URL -c "SELECT sid, expire FROM session ORDER BY expire DESC LIMIT 5;"
```

### 쿠키 디버깅
브라우저 개발자도구 → Application → Cookies에서:
- `connect.sid` 쿠키가 발급됐는지
- `Secure`, `HttpOnly`, `SameSite` 속성 확인

### SSE 디버깅
- Network 탭에서 EventStream 요청 확인
- 응답 헤더의 `Content-Type: text/event-stream` 확인

### 로그 확인
- 개발: 워크플로우 콘솔
- 프로덕션: Replit Deployments → Logs 탭
