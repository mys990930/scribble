# sync test

## Outbox (push)
- 미전송 이벤트 3개 → push 호출, 성공 시 markSent
- push 실패 → 이벤트 유지, 재시도 가능
- 미전송 이벤트 0개 → push 호출 안 함

## Inbox (pull)
- 서버에 변경 2건 → applyChanges + 커서 갱신
- 변경 0건 → 커서만 갱신
- tombstone 포함 → 로컬 soft delete

## Conflict (LWW)
- 로컬 timestamp < 서버 timestamp → 서버 우선
- 로컬 timestamp > 서버 timestamp → 로컬 유지
- 동일 timestamp → 서버 우선 (tie-break)

## Cursor
- 초기 상태 (첫 동기화) → 전체 pull
- 커서 존재 → 증분 pull

## 경계 케이스
- 네트워크 끊김 중 write → outbox에 적재, 복구 후 push
- 동일 엔티티 여러 번 수정 → 최신 이벤트만 push (또는 모두 push, 서버가 LWW)
- deviceId 동일 이벤트 → 자기 자신 변경, pull 시 skip
