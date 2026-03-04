# sync

## 목표

로컬 변경의 서버 전송(outbox)과 서버 변경의 로컬 반영(inbox), 충돌 해결, 커서 관리를 통합 처리한다.

## 책임

- Outbox: 로컬 write 이벤트를 전송 큐에 적재, 서버 push
- Inbox: 서버에서 변경분 pull, 로컬 DB 반영
- Cursor: 증분 동기화 포인터(last sync timestamp/version) 관리
- Conflict: LWW(Last Writer Wins) 기반 충돌 해결
- Tombstone: soft delete 마커 관리
- 초기 동기화 (전체 pull)

## 비책임

- 도메인 비즈니스 규칙 → 각 domain 모듈
- HTTP 통신 구현 → `api-client`
- DB 저장 구현 → `storage-sqlite`
- 인증/세션 → adapter

## 의존 모듈

- `shared/kernel` — 이벤트 버스, Result 타입
- 각 domain 모듈의 엔티티 타입 (동기화 대상 식별)

## 의존 방향

```
sync → shared/kernel, *_domain (엔티티 타입 참조)
sync ← app_shell (sync 시작/중단), api_client(implements), storage_sqlite(implements)
```
