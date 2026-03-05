# memo-usecases

## 목표

Memo의 CRUD, 정렬, 알람 대상 판정을 조율한다.

## 책임

- Memo CRUD (추가, 수정, 삭제, 완료/복원 토글)
- urgentOrder 할당 및 재정렬 로직 (dueAt 기반 자동 삽입, 드래그 재정렬)
- 활성/완료 메모 목록 조회
- 알람 체크 오케스트레이션 (`shouldNotifyAlarm` 호출)
- 저장소 인터페이스 정의 (`MemoRepository`)
- 서비스 구현 (`MemoServiceImpl`)

## 비책임

- 비즈니스 규칙 판정 구현 자체 → `memo-domain`
- DB 구현 → `storage-sqlite`
- 알림 실제 발송 → adapter (UI/플랫폼 알림)
- Memo→Note, Memo→Calendar 전환 → 추후 분리 예정
- UI → `ui-memo`
- 위젯 동기화 → `app-shell`, `widget-todo`

## 의존 모듈

- `memo-domain` — Memo 엔티티, 순수 함수
- `shared/kernel` — ID 생성

## 의존 방향

```
memo_usecases → memo_domain, shared/kernel
memo_usecases ← ui_memo, app_shell/di
memo_usecases ← storage_sqlite, api_client (implements repo)
```
