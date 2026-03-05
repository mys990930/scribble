# app-shell

## 목표

앱 진입점, 라우팅, DI 구성, 전역 생명주기를 담당한다.

## 책임

- main() 진입점
- MaterialApp 구성 (테마 적용, 라우트 등록)
- ProviderScope (Riverpod DI 루트)
- **플랫폼 조건부 DI** (`di/` — 네이티브: SQLite, 웹: API)
- 위젯 동기화 게이트 (_WidgetSyncGate) — 네이티브 전용, 웹에서 비활성
- 앱 resume 시 동기화 트리거 — 네이티브 전용
- HomeScreen (탭 네비게이션)

## 비책임

- 개별 화면 → 각 `ui-*`
- 비즈니스 로직 → usecases / domain
- DB → `storage-sqlite`

## 의존 모듈

- 모든 `ui-*` (라우팅 대상)
- `sync` (resume 시 트리거)
- `shared/ui` (테마)
- `shared/kernel`
- flutter_riverpod

## 조건부 DI 구조

```
app_shell/di/
  di.dart           ← 진입점 (조건부 import)
  di_native.dart    ← dart.library.io → DriftMemoService
  di_web.dart       ← dart.library.js_interop → ApiMemoService
  di_stub.dart      ← fallback (analyzer용)
```

컴파일 타임에 플랫폼별 파일만 포함되므로, 웹 빌드에 dart:ffi / drift 코드가 유입되지 않는다.

## 의존 방향

```
app_shell → ui_*, sync, shared/ui, shared/kernel
app_shell → storage_sqlite (네이티브만, di_native.dart)
app_shell → api_client (웹만, di_web.dart)
app_shell ← (없음 — 최상위)
```
