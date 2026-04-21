# 🗄️ 데이터베이스

> PostgreSQL + Drizzle ORM. 스키마 정의는 `shared/schema.ts`에 위치합니다.

## 마이그레이션

```bash
npm run db:push       # 스키마 변경을 DB에 푸시
npm run db:push --force  # 데이터 손실 가능 변경 강제 적용
```

## 테이블 구조

### `wines` — 와인 카탈로그 (231종)
| 컬럼 | 타입 | 설명 |
|------|------|------|
| id | serial PK | |
| name | text | 와인명 |
| type | text | Red/White/Sparkling/Rosé/Fortified/Dessert |
| nation | text | 원산지 국가 |
| region | text | 지역 |
| variety | text | 포도 품종 |
| vintage | integer | 빈티지 |
| price | integer | 가격 (KRW) |
| tastingNotes | text | 시음 노트 |
| imageUrl | text | 이미지 URL |
| ... | | 기타 와인 속성 |

### `occasions` — 와인-상황 매핑
| 컬럼 | 타입 | 설명 |
|------|------|------|
| id | serial PK | |
| wineId | integer FK | wines.id |
| occasion | text | 상황/용도 (예: "데이트", "선물") |

### `users` — 사용자
| 컬럼 | 타입 | 설명 |
|------|------|------|
| id | serial PK | |
| email | text unique | 이메일 |
| password | text | bcrypt 해시 |
| name | text | 이름 |
| role | text | "user" 또는 "admin" |
| createdAt | timestamp | 가입일 |

### `conversations` — 대화 세션 (회원 전용)
| 컬럼 | 타입 | 설명 |
|------|------|------|
| id | serial PK | |
| userId | integer FK | users.id |
| title | text | 대화 제목 (자동 생성) |
| createdAt | timestamp | |

### `messages` — 채팅 메시지
| 컬럼 | 타입 | 설명 |
|------|------|------|
| id | serial PK | |
| conversationId | integer FK | conversations.id |
| role | text | "user" 또는 "assistant" |
| content | text | 메시지 내용 |
| createdAt | timestamp | |

### `keywordLib` — 키워드 매핑 라이브러리
| 컬럼 | 타입 | 설명 |
|------|------|------|
| id | serial PK | |
| keyword | text | 키워드 |
| category | text | 분류 |

### `session` — 세션 저장소 (`connect-pg-simple` 자동 생성)
| 컬럼 | 타입 | 설명 |
|------|------|------|
| sid | varchar PK | 세션 ID |
| sess | json | 세션 데이터 |
| expire | timestamp | 만료 시각 |

## 관계도

```
users ──< conversations ──< messages
wines ──< occasions
```

## 한↔영 검색 매핑

`server/storage.ts`에서 한국어 검색어를 영어 데이터에 매칭:

**국가 18개**
- 프랑스 ↔ France, 이탈리아 ↔ Italy, 미국 ↔ USA, 칠레 ↔ Chile, …

**와인 종류 6개**
- 레드 ↔ Red, 화이트 ↔ White, 스파클링 ↔ Sparkling, 로제 ↔ Rosé, 주정강화 ↔ Fortified, 디저트 ↔ Dessert

## 백업 / 복원

```bash
# 백업
pg_dump $DATABASE_URL > backup.sql

# 복원
psql <new-database-url> < backup.sql
```

## 시딩

`attached_assets/`의 CSV 파일을 `csv-parse`로 읽어 초기 와인 데이터를 삽입합니다.
