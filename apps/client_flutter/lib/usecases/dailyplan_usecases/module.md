# dailyplan-usecases

## 목표

Daily Plan의 CRUD와 오늘 플랜 생성/편집 흐름을 조율한다.

## 책임

- 플랜 CRUD (생성, 수정, 삭제)
- 요일 템플릿 관리 (요일 할당/해제)
- 오늘 플랜 인스턴스 조회 (planForDate 호출)
- Routine 추가/수정/삭제 (도메인 유효성 위임)
- 저장소 인터페이스 정의 (DailyPlanRepository abstract class)

## 비책임

- 비즈니스 규칙 판정 → `dailyplan-domain`
- DB 구현 → `storage-sqlite`
- UI 상태 관리 → `ui-dailyplan`

## 의존 모듈

- `dailyplan-domain` — 엔티티, 유효성 함수
- `shared/kernel` — Result 타입

## 의존 방향

```
dailyplan_usecases → dailyplan_domain, shared/kernel
dailyplan_usecases ← ui_dailyplan, storage_sqlite(implements repo)
```
