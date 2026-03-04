# memo-usecases

## 목표

Memo의 CRUD, 정렬, 알람 체크, 그리고 Memo→Note·Memo→Calendar 흐름을 조율한다.

## 책임

- Memo CRUD (추가, 수정, 삭제, 완료/복원 토글)
- urgentOrder 할당 및 재정렬 로직 (dueAt 기반 자동 삽입, 드래그 재정렬)
- 활성/완료 메모 목록 조회
- 알람 체크 오케스트레이션 (shouldNotifyAlarm 호출 → 알림 발송 위임)
- Memo→Note 전환 흐름
- Memo→Calendar 전환 흐름
- 저장소 인터페이스 정의 (MemoRepository abstract class)

## 비책임

- 비즈니스 규칙 판정 → `memo-domain`
- DB 구현 → `storage-sqlite`
- 알림 실제 발송 → adapter (notification service)
- Note/Calendar 저장 → 각각의 usecases (인터페이스 주입)
- UI → `ui-memo`
- 위젯 동기화 → `widget-todo`

## 의존 모듈

- `memo-domain` — Memo 엔티티, 순수 함수
- `note-domain` — Note 타입 (전환 시)
- `calendar-domain` — CalendarEvent 타입 (전환 시)
- `shared/kernel` — ID 생성, Result 타입

## 의존 방향

```
memo_usecases → memo_domain, note_domain, calendar_domain, shared/kernel
memo_usecases ← ui_memo, widget_todo, storage_sqlite(implements repo)
```
