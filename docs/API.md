# 📡 API 명세

> Base URL: `https://<your-app>.replit.app` (production) / `http://localhost:5000` (development)

모든 응답은 JSON 형식이며, 인증이 필요한 엔드포인트는 세션 쿠키(httpOnly)를 사용합니다.

---

## 🔐 인증 (Auth)

### `POST /api/auth/register`
새 계정 생성

**Request Body**
```json
{
  "email": "user@example.com",
  "password": "min6chars",
  "name": "홍길동"
}
```

**Response (200)**
```json
{
  "id": 1,
  "email": "user@example.com",
  "name": "홍길동",
  "role": "user",
  "createdAt": "2026-01-31T02:35:38.886Z"
}
```

> 최초 가입자는 자동으로 `role: "admin"` 부여

---

### `POST /api/auth/login`
로그인

**Request Body**
```json
{
  "email": "user@example.com",
  "password": "yourpassword"
}
```

**Response (200)** — 사용자 객체 반환 + 세션 쿠키 발급

---

### `POST /api/auth/logout`
로그아웃 (세션 폐기)

**Response (200)**
```json
{ "success": true }
```

---

### `GET /api/auth/me`
현재 로그인한 사용자 조회

**Response (200)** — 사용자 객체  
**Response (401)** — 비로그인 상태

---

### `PATCH /api/auth/password`
비밀번호 변경 (인증 필요)

**Request Body**
```json
{
  "currentPassword": "old",
  "newPassword": "new"
}
```

---

## 🍷 와인 (Wines)

### `GET /api/wines`
와인 목록 조회 (필터/검색 지원)

**Query Parameters**
| 파라미터 | 타입 | 설명 |
|----------|------|------|
| `search` | string | 이름/품종/국가 검색 (한↔영 매핑) |
| `type` | string | Red, White, Sparkling, Rosé, Fortified, Dessert |
| `nation` | string | 국가명 (한국어/영어) |
| `occasion` | string | 용도/상황 |
| `minPrice` | number | 최소 가격 |
| `maxPrice` | number | 최대 가격 |
| `limit` | number | 페이지당 개수 |
| `offset` | number | 오프셋 |

---

### `GET /api/wines/:id`
와인 상세 조회

---

### `GET /api/wines/featured`
추천(Trending) 와인 목록

---

### `GET /api/occasions`
전체 용도/상황 목록

---

## 💬 AI 소믈리에 (Sommelier)

### `POST /api/sommelier/chat` 🔒
회원용 AI 채팅 (DB 저장)

**Request Body**
```json
{
  "message": "오늘 저녁 스테이크에 어울리는 와인 추천해 주세요",
  "conversationId": 123
}
```

**Response**: `text/event-stream` (SSE)
```
data: {"type":"chunk","content":"스테이크"}
data: {"type":"chunk","content":"에는..."}
data: {"type":"done","conversationId":123}
```

---

### `POST /api/sommelier/chat/guest`
비로그인 사용자용 AI 채팅 (DB 저장 안 함)

**Request Body**
```json
{
  "message": "추천해 주세요",
  "history": [
    { "role": "user", "content": "..." },
    { "role": "assistant", "content": "..." }
  ]
}
```

**Response**: SSE 스트리밍 (history 클라이언트 메모리 관리)

---

### `GET /api/conversations` 🔒
사용자의 대화 목록 (검색 지원)

**Query**
- `search`: 키워드 검색

---

### `GET /api/conversations/:id` 🔒
특정 대화의 메시지 목록

---

## 👨‍💼 관리자 (Admin)

> 모든 admin 엔드포인트는 `role: "admin"` 사용자만 접근 가능

### `GET /api/admin/users` 🔒
전체 사용자 목록

---

### `PATCH /api/admin/users/:id` 🔒
사용자 정보 수정 (이름, 역할)

**Request Body**
```json
{
  "name": "새 이름",
  "role": "admin"
}
```

---

### `DELETE /api/admin/users/:id` 🔒
사용자 삭제 (본인 삭제 불가)

---

### `POST /api/admin/users/:id/reset-password` 🔒
사용자 비밀번호 초기화

**Request Body**
```json
{ "newPassword": "tempPassword123" }
```

---

## 에러 응답 형식

```json
{
  "error": "에러 메시지",
  "details": { /* 선택적 추가 정보 */ }
}
```

### 주요 상태 코드
- `200` 성공
- `400` 잘못된 요청 (검증 실패)
- `401` 인증 필요
- `403` 권한 부족
- `404` 리소스 없음
- `500` 서버 에러
