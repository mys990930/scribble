# widget-calendar

## 목표

Calendar의 네이티브 홈 화면 위젯을 담당한다.

## 책임

- 오늘 일정 요약 표시
- v1: 읽기 전용

## 비책임

- 이벤트 로직 → `calendar-usecases`
- 네이티브 레이아웃 → 플랫폼별

## 의존 모듈

- `calendar-domain` — CalendarEvent 타입

## 의존 방향

```
widget_calendar → calendar_domain
widget_calendar ← app_shell (초기화)
```
