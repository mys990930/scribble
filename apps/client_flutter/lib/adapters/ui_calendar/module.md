# ui-calendar

## 목표

Calendar 기능의 Flutter 화면을 담당한다.

## 책임

- CalendarScreen: 일/주/월 뷰 전환, 이벤트 표시
- 이벤트 생성/편집 화면
- Daily Plan 연계 표시

## 비책임

- 이벤트 비즈니스 규칙 → `calendar-domain`
- CRUD → `calendar-usecases`
- 테마 → `shared/ui`

## 의존 모듈

- `calendar-usecases`
- `calendar-domain`
- `shared/ui`

## 의존 방향

```
ui_calendar → calendar_usecases, calendar_domain, shared/ui
ui_calendar ← app_shell
```
