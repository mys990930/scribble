# ui-memo

## 목표

Memo 기능의 Flutter 화면과 상태 관리를 담당한다.

## 책임

- MemoScreen: 활성 메모 목록, 드래그 재정렬, 완료 토글
- MemoEditScreen: 메모 편집, 기한 프리셋(1h/6h/12h/1d/커스텀), 알람 토글, 삭제
- MemoHistoryScreen: 완료 메모 목록, 복원
- 메모 관련 Riverpod provider 정의 (activeMemosProvider, resolvedMemosProvider, memoRepoProvider)
- 알람 체크 타이머 (1분 주기) 및 로컬 알림 발송
- 위젯 동기화 MethodChannel 호출 (데이터 변경 시 widget-todo에 push)

## 비책임

- Memo 비즈니스 규칙 → `memo-domain`
- 정렬/CRUD 로직 → `memo-usecases`
- DB 구현 → `storage-sqlite`
- 네이티브 위젯 렌더링 → `widget-todo`
- 테마/색상 → `shared/ui`

## 의존 모듈

- `memo-usecases` — MemoRepository, usecase 호출
- `memo-domain` — Memo 엔티티
- `shared/ui` — AppColors, 테마
- `shared/kernel` — (간접)
- Flutter SDK, flutter_riverpod, flutter_local_notifications

## 의존 방향

```
ui_memo → memo_usecases, memo_domain, shared/ui
ui_memo ← app_shell (라우팅)
```
