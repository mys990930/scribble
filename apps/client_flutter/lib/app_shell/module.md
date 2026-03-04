# app-shell

## 목표

앱 진입점, 라우팅, DI 구성, 전역 생명주기를 담당한다.

## 책임

- main() 진입점
- MaterialApp 구성 (테마 적용, 라우트 등록)
- ProviderScope (Riverpod DI 루트)
- 위젯 동기화 게이트 (_WidgetSyncGate)
- 앱 resume 시 동기화 트리거
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

## 의존 방향

```
app_shell → ui_*, sync, shared/ui, shared/kernel
app_shell ← (없음 — 최상위)
```
