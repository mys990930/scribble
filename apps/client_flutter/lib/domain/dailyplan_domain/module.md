# dailyplan-domain

## 목표

Daily Plan / Routine / Tag / 시간 슬롯의 순수 비즈니스 규칙을 정의한다.

## 책임

- DailyPlan 엔티티: id, name, date(1회성), days(요일 반복)
- Routine 엔티티: id, planId, name, detail, startTime, endTime, tag
- Quick Tag 정책: 고정(Work/Rest/Sleep) + 커스텀 태그, color 매핑
- 10분 단위 시간 정규화 (`is10MinAligned`, `validateRoutineTimes`)
- Routine 겹침 허용 규칙 (겹침 감지는 하되 차단하지 않음)
- 요일별 템플릿 규칙: Weekday enum, Plan↔Weekday 매핑
- 날짜별 플랜 인스턴스 판정: 1회성 날짜 매칭 우선, 요일 매칭 폴백
- 현재 시간 기준 진행률 판정: Plan 전체 / 개별 Routine

## 비책임

- 영속화 → `storage-sqlite`
- 플랜 CRUD 오케스트레이션 → `dailyplan-usecases`
- UI 렌더링 → `ui-dailyplan`
- 위젯 표시 → `widget-dailyplan`

## 의존 모듈

- `shared/kernel` — ID 타입, time util

## 의존 방향

```
dailyplan_domain → shared/kernel (only)
dailyplan_domain ← dailyplan_usecases, ui_dailyplan, storage_sqlite
```
