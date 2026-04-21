# 🔄 백업 복원 가이드

이 폴더에는 AI Wine Sommelier 프로젝트의 전체 백업이 들어 있습니다.

## ⚠️ 보안 경고

**이 폴더의 파일들은 민감한 정보(비밀번호 해시, API 키, 세션)를 포함합니다.**

- ❌ Git에 커밋하지 마세요
- ❌ 외부 클라우드(공개 저장소, 채팅 등)에 업로드하지 마세요
- ❌ 타인과 공유하지 마세요
- ✅ 안전한 로컬 저장소에 보관하세요
- ✅ 암호화된 저장소(예: 1Password, Bitwarden) 사용 권장

---

## 📦 포함된 파일

| 파일 | 설명 | 크기 |
|------|------|------|
| `database_backup.sql` | PostgreSQL 전체 덤프 (와인, 사용자, 대화 등) | 약 308KB |
| `sessions_export.csv` | 현재 활성 세션 데이터 | 작음 |
| `.env.backup` | 환경변수 / Secrets | 약 1KB |
| `README_복원가이드.md` | 이 문서 | - |

---

## 🚀 복원 방법

### 1. 환경변수 복원
```bash
# 백업 파일을 .env로 복사
cp .env.backup ../.env

# 또는 Replit Secrets에 수동 등록
# 좌측 자물쇠 아이콘 → 각 변수 추가
```

### 2. 데이터베이스 복원

#### 방법 A: 새 PostgreSQL DB에 복원
```bash
# 새 DB URL을 환경변수로 설정
export NEW_DB_URL="postgres://user:pass@host:5432/dbname"

# 복원 실행
psql "$NEW_DB_URL" < database_backup.sql
```

#### 방법 B: 기존 DB 초기화 후 복원
```bash
# ⚠️ 주의: 기존 데이터가 모두 삭제됩니다
psql "$DATABASE_URL" -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public;"
psql "$DATABASE_URL" < database_backup.sql
```

### 3. 세션 데이터 복원 (선택)
세션은 일반적으로 만료되므로 복원할 필요는 없습니다.  
필요한 경우만:
```bash
# database_backup.sql에 이미 session 테이블이 포함되어 있음
# 별도 CSV는 참고용
```

---

## 🔍 백업 내용 확인

### DB 백업 미리보기
```bash
# 테이블 목록 확인
grep "^CREATE TABLE" database_backup.sql

# 데이터 건수 추정
grep -c "^INSERT" database_backup.sql
```

### 와인 데이터 추출 (CSV로)
```bash
# 복원 후
psql "$DATABASE_URL" -c "\COPY (SELECT * FROM wines) TO 'wines.csv' WITH CSV HEADER"
```

---

## 📌 주의사항

### OpenAI API 키
`.env.backup`의 `AI_INTEGRATIONS_OPENAI_API_KEY`는 **Replit 환경에서만 동작**합니다.  
다른 환경에서 사용하려면 [OpenAI 대시보드](https://platform.openai.com/api-keys)에서 본인의 키를 발급받아 교체하세요.

### 비밀번호
모든 사용자 비밀번호는 **bcrypt 해시**로 저장되어 있어 원본을 알 수 없습니다.  
계정 접근이 필요하면 관리자 페이지에서 비밀번호를 재설정하세요.

### 세션 시크릿
`SESSION_SECRET`이 바뀌면 기존 세션이 모두 무효화됩니다.  
복원 시 같은 값을 유지하면 기존 세션도 그대로 사용 가능합니다.

---

## 📅 백업 생성 정보
- 생성 시점: 자동 생성
- 프로젝트: AI Wine Sommelier
- 데이터베이스: PostgreSQL (Replit)
