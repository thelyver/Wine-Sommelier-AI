# 📝 변경 이력 (Changelog)

본 프로젝트의 주요 변경 사항을 시간 역순으로 기록합니다.

---

## [2026-04-21] 프로덕션 로그인 버그 수정

### Fixed
- 배포 환경에서 로그인 후 세션이 유지되지 않던 문제 수정
  - `app.set("trust proxy", 1)` 추가
  - 세션 쿠키에 `sameSite: "lax"` 명시

---

## [2026-04 초순] 모바일 최적화

### Added
- iPad Safari viewport 높이 폴백 체인
  - `dvh` → `--vh` CSS 변수 → `-webkit-fill-available`
- `--vh` 동적 갱신 (resize/scroll/focusin/focusout/orientationchange)

### Changed
- 모바일 채팅 오버레이를 `fixed inset-0`에서 `fixed-full-height` 클래스로 교체

---

## [2026-02 ~ 03] UX 개선

### Added
- 히어로 배너 리디자인
- 추천(Trending) 와인 캐러셀
- 플로팅 AI 소믈리에 버튼 (펄스 애니메이션)
- 검색 디바운싱 (300ms)
- 한국어 ↔ 영어 검색 매핑 (18개국, 6종)
- 관리자 비밀번호 초기화 다이얼로그

---

## [2026-01-31] 인증 및 관리자 기능

### Added
- DB 기반 사용자 인증 시스템
  - `users` 테이블, bcrypt 비밀번호 해싱
  - 회원가입 / 로그인 / 로그아웃 API
- PostgreSQL 백엔드 세션 (`connect-pg-simple`)
- 역할 기반 접근 제어 (user / admin)
- 관리자 페이지 (`/admin`)
  - 사용자 목록, 역할 편집, 삭제, 비밀번호 초기화
- 게스트 vs 회원 채팅 차별화
  - 게스트: 메모리 임시 저장 (`/api/sommelier/chat/guest`)
  - 회원: DB 영구 저장 + 검색

---

## [초기] MVP 구축

### Added
- 데이터 모델 정의 (`shared/schema.ts`)
- 와인 카탈로그 시딩 (231종, CSV 기반)
- 와인 검색 / 카테고리 필터 / 상세 필터
- AI 소믈리에 채팅 (SSE 스트리밍)
- 와인 DB 컨텍스트 주입 (hallucination 방지)
- Vivino 풍 디자인 시스템
- 다크/라이트 테마 토글
- Wouter 기반 라우팅

---

## 버전 정책

- **MAJOR**: 호환성 깨지는 변경 (DB 스키마 breaking 등)
- **MINOR**: 기능 추가
- **PATCH**: 버그 수정

> 향후 정식 버전 태깅 시 [Semantic Versioning](https://semver.org/) 따를 예정.
