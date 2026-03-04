# sync-api contracts

## API

| 메서드 | 경로 | 설명 |
|---|---|---|
| POST | /sync/push | 변경 이벤트 수신 |
| POST | /sync/pull | 변경분 반환 |

## DTO

### PushRequest
| 필드 | 타입 |
|---|---|
| deviceId | String |
| events | List\<SyncEvent\> |

### PushResponse
| 필드 | 타입 |
|---|---|
| accepted | int |
| rejected | List\<RejectedEvent\> |

### PullRequest
| 필드 | 타입 |
|---|---|
| deviceId | String |
| cursor | SyncCursor |

### PullResponse
| 필드 | 타입 |
|---|---|
| changes | List\<SyncChange\> |
| cursor | SyncCursor |

(SyncEvent, SyncChange, SyncCursor는 docs/contracts/sync-protocol.md 참조)

## 에러

| 코드 | HTTP | 설명 |
|---|---|---|
| SYNC_INVALID_DEVICE | 403 | 미등록 디바이스 |
| SYNC_CONFLICT | 409 | 충돌 (LWW 후에도 남는 경우) |
| SYNC_CURSOR_EXPIRED | 410 | 커서가 너무 오래됨 → 전체 재동기화 필요 |
