# sync-api test

## push
- 정상 이벤트 3개 → accepted=3
- 미등록 deviceId → SYNC_INVALID_DEVICE
- LWW 충돌 → 서버 최신 우선, accepted

## pull
- 커서 이후 변경 2건 → 2건 반환 + 새 커서
- 변경 없음 → 빈 changes + 동일 커서
- 커서 만료 → SYNC_CURSOR_EXPIRED

## 경계 케이스
- 동일 엔티티 push 2회 → LWW로 최신만 유지
- tombstone 포함 pull → isTombstone=true 전달
- 자기 디바이스 변경 → pull에서 제외
