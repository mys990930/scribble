# calendar-domain

## 목표

앱 내부 캘린더 이벤트의 순수 비즈니스 규칙을 정의한다.

## 책임

- CalendarEvent 엔티티: id, title, description, startTime, endTime, allDay, color
- 이벤트 시간 유효성 검증 (end > start)
- 날짜/주/월 범위 쿼리용 필터 규칙
- Memo→Calendar 전환 시 이벤트 생성 규칙

## 비책임

- 영속화 → `storage-sqlite`
- CRUD 오케스트레이션 → `calendar-usecases`
- UI 렌더링 → `ui-calendar`
- 외부 캘린더 연동 → v1 비대상

## 의존 모듈

- `shared/kernel`

## 의존 방향

```
calendar_domain → shared/kernel (only)
calendar_domain ← calendar_usecases, ui_calendar, storage_sqlite
```
