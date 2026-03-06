# ui-memo

## 목표

Memo 기능의 Flutter 화면과 상태 관리를 담당한다.

## 책임

- MemoScreen: 활성 메모 목록, 드래그 재정렬, 완료 토글, 당겨서 새로고침(Pull-to-Refresh)
- MemoEditScreen: 메모 편집, 기한 프리셋(1h/6h/12h/1d/커스텀), 알람 토글, 삭제
- MemoHistoryScreen: 완료 메모 목록, 복원
- 메모 관련 Riverpod provider 정의 (`activeMemosProvider`, `resolvedMemosProvider`)
- 활성 메모 캐시 유지 + 백그라운드 refresh 상태 관리 (초기/갱신 UX 분리)
- 알람 체크 타이머(1분 주기) + 로컬 알림 표시 (네이티브 전용)

## 비책임

- Memo 비즈니스 규칙 → `memo-domain`
- Memo 정렬/알람 대상 판정/CRUD 오케스트레이션 → `memo-usecases`
- 위젯 동기화 타이밍 제어 → `app-shell`
- `memoServiceProvider` 정의 및 구현 선택 → `app_shell/di` (조건부 DI)
- 위젯 MethodChannel sync/consume → `app-shell` (`_WidgetSyncGate`)
- DB 구현 → `storage-sqlite`
- 네이티브 위젯 렌더링 → `widget-todo`
- 테마/색상 → `shared/ui`

## 의존 모듈

- `app_shell/di` — memoServiceProvider (re-export)
- `memo-domain` — Memo 엔티티
- `shared/ui` — AppColors, 테마
- Flutter SDK, flutter_riverpod, flutter_local_notifications

## 의존 방향

```
ui_memo → app_shell/di (memoServiceProvider), memo_domain, shared/ui
ui_memo ← app_shell (라우팅)
```
