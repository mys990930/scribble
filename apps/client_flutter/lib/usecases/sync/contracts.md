# sync contracts

## 인터페이스

### SyncRemote (abstract)

| 메서드 | 설명 |
|---|---|
| push(List\<SyncEvent\>) → Future\<PushResult\> | 로컬 변경 서버 전송 |
| pull(SyncCursor) → Future\<PullResult\> | 서버 변경분 가져오기 |

### SyncStorage (abstract)

| 메서드 | 설명 |
|---|---|
| getPendingEvents() → Future\<List\<SyncEvent\>\> | 미전송 이벤트 |
| markSent(List\<String\> eventIds) → Future\<void\> | 전송 완료 처리 |
| applyCh changes(List\<SyncChange\>) → Future\<void\> | 서버 변경 로컬 반영 |
| getCursor() → Future\<SyncCursor\> | 현재 커서 |
| saveCursor(SyncCursor) → Future\<void\> | 커서 저장 |

## DTO

### SyncEvent

| 필드 | 타입 | 설명 |
|---|---|---|
| id | String | 이벤트 ID |
| entityType | String | 대상 엔티티 종류 (memo, plan, note 등) |
| entityId | String | 대상 엔티티 ID |
| action | String | create / update / delete |
| payload | Map\<String, dynamic\> | 변경 데이터 |
| timestamp | DateTime | 발생 시각 |
| deviceId | String | 발생 디바이스 ID |

### SyncCursor

| 필드 | 타입 | 설명 |
|---|---|---|
| lastSyncTimestamp | DateTime | 마지막 동기화 시각 |
| version | int | 동기화 버전 |

### PullResult

| 필드 | 타입 | 설명 |
|---|---|---|
| changes | List\<SyncChange\> | 변경 목록 |
| cursor | SyncCursor | 갱신된 커서 |

### SyncChange

| 필드 | 타입 | 설명 |
|---|---|---|
| entityType | String | 엔티티 종류 |
| entityId | String | 엔티티 ID |
| action | String | create / update / delete |
| payload | Map\<String, dynamic\>? | 데이터 (delete 시 null) |
| timestamp | DateTime | 서버 시각 |
| isTombstone | bool | soft delete 여부 |

## 충돌 해결

- **LWW**: 동일 entityId에 대해 timestamp가 더 늦은 쪽 우선
- **Tombstone**: delete는 soft delete로 기록, pull 시 tombstone 확인 후 로컬 제거

## 동기화 흐름

1. `push`: pendingEvents → SyncRemote.push() → markSent
2. `pull`: getCursor → SyncRemote.pull(cursor) → applyChanges → saveCursor
3. 주기: app resume 시 + 주기적 타이머 (configurable)
