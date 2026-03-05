# storage-sqlite

## 목표

Drift(SQLite) 기반으로 모든 도메인 Repository 인터페이스를 구현한다.
**네이티브 플랫폼(모바일/데스크톱) 전용** — 웹에서는 사용되지 않는다.

## 책임

- AppDatabase 정의 (Drift, 스키마 버전 관리, 마이그레이션)
- 테이블 정의 (Memos, DailyPlans, PlanDays, Routines + 향후 CalendarEvents, Notes, Archives)
- DAO 구현 (MemoDao, DailyPlanDao, RoutineDao 등)
- Repository 구현체 (DriftMemoService 등)
- 도메인 ↔ DB 모델 매핑 (mappers)
- enum TypeConverter (WeekdayConv, RoutineTypeConv 등)
- SyncStorage 구현 (outbox/cursor 테이블)

## 비책임

- Repository 인터페이스 정의 → 각 usecase 모듈
- 도메인 비즈니스 규칙 → domain 모듈
- HTTP 통신 → `api-client`
- 웹 플랫폼 데이터 접근 → `api-client` (ApiMemoService)

## 플랫폼 제한

이 모듈은 `dart:ffi` 기반 SQLite 바인딩을 사용하므로 웹에서 import할 수 없다.
`app_shell/di/di_native.dart`에서만 참조되며, 조건부 import로 웹 빌드에서 제외된다.

## 의존 모듈

- 각 domain 모듈 — 엔티티 타입 (매핑 대상)
- 각 usecase 모듈 — MemoService 등 인터페이스 (implements)
- `shared/kernel` — ID 생성
- drift, path_provider, sqlite3_flutter_libs

## 의존 방향

```
storage_sqlite → *_domain (엔티티 타입), shared/kernel
storage_sqlite -.implements.-> *_usecases (MemoService 등)
storage_sqlite -.implements.-> sync (SyncStorage)
storage_sqlite ← app_shell/di/di_native.dart (네이티브 전용)
```
