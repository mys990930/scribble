# ui-memo

## 목표

Memo 기능의 Flutter 화면과 상태 관리를 담당한다.

## 책임

- MemoScreen: 활성 메모 목록, 드래그 재정렬, 완료 토글
- MemoEditScreen: 메모 편집, 기한 프리셋(1h/6h/12h/1d/커스텀), 알람 토글, 삭제
- MemoHistoryScreen: 완료 메모 목록, 복원
- 메모 관련 Riverpod provider 정의 (activeMemosProvider, resolvedMemosProvider)
- 알람 체크 타이머 (1분 주기) 및 로컬 알림 발송 — 네이티브 전용
- 위젯 동기화 MethodChannel 호출 — 네이티브 전용

## 비책임

- Memo 비즈니스 규칙 → `memo-domain`
- MemoService 인터페이스/구현 → `memo-usecases` / `storage-sqlite` or `api-client`
- **memoServiceProvider 정의** → `app_shell/di/` (조건부 DI)
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
