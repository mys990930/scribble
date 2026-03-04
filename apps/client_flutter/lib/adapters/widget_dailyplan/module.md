# widget-dailyplan

## 목표

Daily Plan의 네이티브 홈 화면 위젯을 담당한다.

## 책임

- 현재 진행 중 루틴 + 다음 루틴 표시
- v1: 읽기 전용

## 비책임

- Plan/Routine 로직 → `dailyplan-usecases`
- 네이티브 레이아웃 → 플랫폼별

## 의존 모듈

- `dailyplan-domain` — DailyPlan, Routine 타입

## 의존 방향

```
widget_dailyplan → dailyplan_domain
widget_dailyplan ← app_shell (초기화)
```
