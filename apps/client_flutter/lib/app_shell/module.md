# app-shell

## 목표

앱 진입점, 라우팅, DI 구성, 전역 생명주기를 담당한다.

## 책임

- main() 진입점
- MaterialApp 구성 (테마 적용, 라우트 등록)
- ProviderScope (Riverpod DI 루트)
- 플랫폼 조건부 DI (`di/` — 네이티브: SQLite repo, 웹: API repo)
- 위젯 동기화 게이트 (`_WidgetSyncGate`) — 네이티브 전용, 웹에서 비활성
- 앱 resume 시 pending memo consume + widget sync 트리거
- 앱 시작 시 pending share 확인 및 ui-archive 공유 플로우 전달

## 비책임

- 개별 화면 → 각 `ui-*`
- 비즈니스 규칙/유스케이스 구현 → `*_usecases`, `*_domain`
- DB 구현 → `storage-sqlite`

## 조건부 DI 구조

```
app_shell/di/
  di.dart        ← 진입점 (조건부 import)
  di_native.dart ← dart.library.io → MemoServiceImpl(DriftMemoRepository)
  di_web.dart    ← dart.library.js_interop → MemoServiceImpl(ApiMemoRepository)
  di_stub.dart   ← fallback (analyzer용)
```

## 의존 방향

```
app_shell → ui_*, shared/ui, shared/kernel
app_shell → storage_sqlite (네이티브만, di_native.dart)
app_shell → api_client (웹만, di_web.dart)
app_shell ← (없음 — 최상위)
```
