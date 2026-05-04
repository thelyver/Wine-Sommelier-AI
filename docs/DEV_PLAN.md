# joomoon.ai 개발 계획

> PRD v0.2 기반 | 최종 업데이트: 2026-05-04

---

## 전체 일정 한눈에

```
2026년
5월 ━━━━━━━━━━━━━━━━ Phase 1 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
     Sprint 1 (5/4~5/17)        Sprint 2 (5/18~5/31)
     버그·보안·기반              AI 고도화 + 어드민

6월 ━━━━━━━━━━━━━━━━ Phase 2 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
     Sprint 3 (6/1~6/14)        Sprint 4 (6/15~6/30)
     주문 시스템 MVP              공급자 포털

7~9월 ━━━━━━━━━━━━━━ Phase 3 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
     PG 결제, 검색 고도화, 마케팅 도구

이후 ━━━━━━━━━━━━━━━ joomoonAI 앱 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
     별도 PRD 작성 후 착수
```

---

## Phase 1 — 기반 안정화 & AI 고도화
**기간**: 2026.05.04 ~ 05.31 | **목표**: 안정적으로 돌아가는 서비스 + AI 차별점 확보

### Sprint 1 (5/4 ~ 5/17) — 버그·보안·기반

| 순서 | 이슈 | 작업 내용 | 담당 | 난이도 |
|------|------|-----------|------|--------|
| 1 | [#1](https://github.com/thelyver/Wine-Sommelier-AI/issues/1) | OpenAI API 키 변수명 수정 | Claude Code | 🟢 쉬움 |
| 2 | [#8](https://github.com/thelyver/Wine-Sommelier-AI/issues/8) | API Rate Limiting 적용 | Claude Code | 🟢 쉬움 |
| 3 | [#2](https://github.com/thelyver/Wine-Sommelier-AI/issues/2) | 소믈리에 API 인증 미적용 수정 | Claude Code | 🟡 보통 |
| 4 | [#3](https://github.com/thelyver/Wine-Sommelier-AI/issues/3) | 와인 이미지 컬럼 추가 + 업로드 | Claude Code | 🟡 보통 |

**Sprint 1 완료 기준**
- [ ] AI 채팅이 정상 작동함
- [ ] 로그인하지 않으면 대화가 DB에 저장되지 않음
- [ ] 와인 카드에 이미지가 표시됨

---

### Sprint 2 (5/18 ~ 5/31) — AI 고도화 + 어드민

| 순서 | 이슈 | 작업 내용 | 담당 | 난이도 |
|------|------|-----------|------|--------|
| 1 | [#11](https://github.com/thelyver/Wine-Sommelier-AI/issues/11) | AI 소믈리에 프롬프트 고도화 | Claude Code | 🔴 높음 |
| 2 | [#11](https://github.com/thelyver/Wine-Sommelier-AI/issues/11) | 가짜 데이터 500개로 확대 + is_sample 플래그 | Claude Code | 🟡 보통 |
| 3 | [#4](https://github.com/thelyver/Wine-Sommelier-AI/issues/4) | 어드민 와인 CRUD (추가/수정/삭제) | Claude Code | 🔴 높음 |

**Sprint 2 완료 기준**
- [ ] AI가 감성적·스토리텔링 방식으로 와인을 추천함
- [ ] 어드민에서 와인을 직접 추가/수정/삭제할 수 있음
- [ ] 가짜 데이터 500개로 AI 성능 시험 가능

---

## Phase 2 — 주문 시스템 MVP
**기간**: 2026.06.01 ~ 06.30 | **목표**: 실제 거래가 일어나는 플랫폼

### Sprint 3 (6/1 ~ 6/14) — 주문 요청 시스템

| 순서 | 이슈 | 작업 내용 | 담당 | 난이도 |
|------|------|-----------|------|--------|
| 1 | [#12](https://github.com/thelyver/Wine-Sommelier-AI/issues/12) | 장바구니 기능 | Claude Code | 🟡 보통 |
| 2 | [#12](https://github.com/thelyver/Wine-Sommelier-AI/issues/12) | 주문서 작성 + 주문 요청 전송 | Claude Code | 🔴 높음 |
| 3 | [#12](https://github.com/thelyver/Wine-Sommelier-AI/issues/12) | 주문 내역 조회 페이지 | Claude Code | 🟡 보통 |
| 4 | [#12](https://github.com/thelyver/Wine-Sommelier-AI/issues/12) | AI 추천 → 장바구니 바로 담기 | Claude Code | 🟡 보통 |

**Sprint 3 완료 기준**
- [ ] 수요자가 장바구니에 와인을 담고 주문 요청을 보낼 수 있음
- [ ] AI가 추천한 와인을 바로 장바구니에 담을 수 있음
- [ ] 주문 내역에서 상태를 확인할 수 있음

---

### Sprint 4 (6/15 ~ 6/30) — 공급자 포털 기초

| 순서 | 이슈 | 작업 내용 | 담당 | 난이도 |
|------|------|-----------|------|--------|
| 1 | [#13](https://github.com/thelyver/Wine-Sommelier-AI/issues/13) | 공급자 가입 + 관리자 승인 흐름 | Claude Code | 🟡 보통 |
| 2 | [#13](https://github.com/thelyver/Wine-Sommelier-AI/issues/13) | 공급자 상품 등록/수정/재고 관리 | Claude Code | 🔴 높음 |
| 3 | [#13](https://github.com/thelyver/Wine-Sommelier-AI/issues/13) | 공급자 주문 수신 + 수락/거절 | Claude Code | 🟡 보통 |
| 4 | [#5](https://github.com/thelyver/Wine-Sommelier-AI/issues/5) | 즐겨찾기 기능 | Claude Code | 🟢 쉬움 |
| 5 | [#6](https://github.com/thelyver/Wine-Sommelier-AI/issues/6) | 모바일 반응형 개선 | Claude Code | 🟡 보통 |
| 6 | [#7](https://github.com/thelyver/Wine-Sommelier-AI/issues/7) | AI 대화 제목 자동 생성 | Claude Code | 🟢 쉬움 |

**Sprint 4 완료 기준**
- [ ] 공급자가 직접 상품을 등록하고 재고를 관리할 수 있음
- [ ] 공급자가 주문을 수신하고 수락/거절할 수 있음
- [ ] 모바일에서도 주요 기능이 불편 없이 작동함

---

## Phase 3 — 플랫폼 확장
**기간**: 2026.07 ~ 09 | **목표**: 수익화 + UX 완성도

| 항목 | 이슈 | 설명 |
|------|------|------|
| PG 결제 연동 | 신규 | 토스페이먼츠 (주문 요청 → 실결제 전환) |
| UI/UX 디자인 개편 | 신규 | 별도 디자인 크루와 협업 |
| 검색 고도화 | [#9](https://github.com/thelyver/Wine-Sommelier-AI/issues/9) | 한/영 동의어, 자동완성 |
| 와인 상세 URL 공유 | [#10](https://github.com/thelyver/Wine-Sommelier-AI/issues/10) | 소셜 공유용 |
| 마케팅 도구 | 신규 | 큐레이션, 배너 관리 |
| 공급자 성과 리포트 | 신규 | 조회수, 전환율 대시보드 |

---

## 역할 분담

| 역할 | 담당 | 하는 일 |
|------|------|---------|
| **Claude Code** | AI 개발자 | 코드 작성, GitHub push, 배포 |
| **오너 (you)** | PO | 방향 결정, 기능 검토, 피드백 |
| **개발자 협업자** | 풀스택 | 복잡한 기능, 코드 리뷰 |
| **디자인 크루** | UI/UX | Phase 3부터 합류 (Claude Design 포함) |

---

## 개발 방식

### 바이브코딩 워크플로우
```
1. 오너가 원하는 것을 말로 설명
      ↓
2. Claude Code가 코드 작성
      ↓
3. GitHub에 자동 push
      ↓
4. Railway에 자동 배포 (3~5분)
      ↓
5. 라이브 사이트에서 바로 확인
      ↓
6. 피드백 → 반복
```

### 브랜치 전략
```
main        → 라이브 서비스 (Railway 자동 배포)
dev         → 개발 통합 브랜치 (추후 설정)
feature/*   → 기능별 개발 브랜치
```

### 이슈 → 개발 흐름
1. GitHub 이슈 확인
2. "이슈 #N 개발해줘" 요청
3. Claude Code가 구현 + push
4. 라이브에서 확인 후 이슈 close

---

## 현재 GitHub 이슈 전체 현황

| 이슈 | 제목 | Phase | 상태 |
|------|------|-------|------|
| [#1](https://github.com/thelyver/Wine-Sommelier-AI/issues/1) | OpenAI 키 버그 | Phase 1 | 🔴 대기 |
| [#2](https://github.com/thelyver/Wine-Sommelier-AI/issues/2) | API 인증 보안 | Phase 1 | 🔴 대기 |
| [#3](https://github.com/thelyver/Wine-Sommelier-AI/issues/3) | 와인 이미지 | Phase 1 | 🔴 대기 |
| [#4](https://github.com/thelyver/Wine-Sommelier-AI/issues/4) | 어드민 와인 CRUD | Phase 1 | 🔴 대기 |
| [#5](https://github.com/thelyver/Wine-Sommelier-AI/issues/5) | 즐겨찾기 | Phase 2 | ⚪ 예정 |
| [#6](https://github.com/thelyver/Wine-Sommelier-AI/issues/6) | 모바일 UX | Phase 2 | ⚪ 예정 |
| [#7](https://github.com/thelyver/Wine-Sommelier-AI/issues/7) | 대화 제목 자동생성 | Phase 2 | ⚪ 예정 |
| [#8](https://github.com/thelyver/Wine-Sommelier-AI/issues/8) | Rate Limiting | Phase 1 | 🔴 대기 |
| [#9](https://github.com/thelyver/Wine-Sommelier-AI/issues/9) | 검색 고도화 | Phase 3 | ⚪ 예정 |
| [#10](https://github.com/thelyver/Wine-Sommelier-AI/issues/10) | 와인 URL 공유 | Phase 3 | ⚪ 예정 |
| [#11](https://github.com/thelyver/Wine-Sommelier-AI/issues/11) | AI 소믈리에 고도화 | Phase 1 | 🔴 대기 |
| [#12](https://github.com/thelyver/Wine-Sommelier-AI/issues/12) | 주문 요청 시스템 | Phase 2 | ⚪ 예정 |
| [#13](https://github.com/thelyver/Wine-Sommelier-AI/issues/13) | 공급자 포털 | Phase 2 | ⚪ 예정 |
