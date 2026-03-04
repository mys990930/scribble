# ui-dailyplan

## 목표

Daily Plan 기능의 Flutter 화면과 상태 관리를 담당한다.

## 책임

- DailyPlanScreen: 선택 날짜의 플랜/루틴 타임라인 표시
- 요일 선택기 (WeeklySelector)
- Plan 타임라인 위젯 (PlanTimeline)
- Routine 카드 위젯 (DailyRoutine)
- 선택 날짜 Riverpod provider (selectedDateProvider, planForSelectedDayProvider)

## 비책임

- Plan/Routine 비즈니스 규칙 → `dailyplan-domain`
- CRUD 오케스트레이션 → `dailyplan-usecases`
- DB → `storage-sqlite`
- 테마 → `shared/ui`

## 의존 모듈

- `dailyplan-usecases`
- `dailyplan-domain` — 엔티티 타입
- `shared/ui`

## 의존 방향

```
ui_dailyplan → dailyplan_usecases, dailyplan_domain, shared/ui
ui_dailyplan ← app_shell
```
