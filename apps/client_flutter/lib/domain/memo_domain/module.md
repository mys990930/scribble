# memo-domain

## 목표

Memo(Todo) 아이템의 순수 비즈니스 규칙을 정의한다.

## 책임

- Memo 엔티티 정의 (id, content, 생성/수정 시각, 완료 상태, 우선순위, 기한, 알람)
- Memo 불변 복사 (`copyWith`) 규칙
- 기한(dueAt) 관련 판정: 초과 여부, 남은 시간 계산
- 알람 발송 조건 판정: 전체 기간 대비 잔여 비율 기반 threshold

## 비책임

- 영속화 (DB 저장/조회) → `storage-sqlite`
- 정렬/재정렬 로직 (urgentOrder 할당) → `memo-usecases`
- UI 표현 → `ui-memo`
- 위젯 동기화 → `widget-todo`
- Memo→Note, Memo→Calendar 흐름 → `memo-usecases`

## 의존 모듈

- `shared/kernel` — ID 타입, Result 타입 (예정)

## 의존 방향

```
memo_domain → shared/kernel (only)
memo_domain ← memo_usecases, ui_memo, storage_sqlite
```
