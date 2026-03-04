# calendar-usecases

## 목표

캘린더 이벤트의 CRUD와 조회 흐름을 조율한다.

## 책임

- CalendarEvent CRUD
- 날짜/주/월 범위 조회 오케스트레이션
- Memo→Calendar 전환 흐름 (fromMemo 호출)
- 저장소 인터페이스 정의 (CalendarEventRepository abstract class)

## 비책임

- 비즈니스 규칙 → `calendar-domain`
- DB 구현 → `storage-sqlite`
- UI → `ui-calendar`
- Memo 조회 → `memo-usecases` (인터페이스 주입)

## 의존 모듈

- `calendar-domain`
- `memo-domain` (Memo 타입 참조, 전환 시)
- `shared/kernel`

## 의존 방향

```
calendar_usecases → calendar_domain, memo_domain, shared/kernel
calendar_usecases ← ui_calendar, storage_sqlite(implements repo)
```
