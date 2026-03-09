# sync_api contracts

## 엔드포인트

### `POST /sync/push`

클라이언트가 로컬 outbox 이벤트를 업로드한다.

Request:

```json
{
  "device_id": "client-generated-id",
  "events": [
    {
      "event_id": "uuid",
      "entity_type": "memo",
      "entity_id": "uuid",
      "operation": "upsert",
      "payload": {"title": "Write docs"},
      "updated_at": "2026-03-09T10:00:00Z",
      "deleted_at": null
    }
  ]
}
```

Response `200`:

```json
{
  "accepted": 1,
  "rejected": 0,
  "server_cursor": "opaque-cursor"
}
```

### `GET /sync/pull?device_id=...&cursor=...`

cursor 이후 변경 이벤트를 반환한다.

Response `200`:

```json
{
  "events": [],
  "next_cursor": "opaque-cursor",
  "has_more": false
}
```

## DTO

- `SyncEventEnvelope`
- `PushRequest`
- `PushResponse`
- `PullResponse`
- `ConflictResolutionResult`
- `CursorState`

## 저장 계약

### `sync_events`

모든 도메인 변경분을 저장하는 append-only 이벤트 테이블.

| 컬럼 | 타입 | 제약 / 설명 |
|---|---|---|
| `id` | `uuid` | PK |
| `event_id` | `uuid` | not null, 클라이언트 생성 이벤트 ID, unique |
| `user_id` | `uuid` | not null, FK -> `users.id` |
| `device_pk` | `uuid` | not null, FK -> `devices.id` |
| `device_id` | `varchar(128)` | not null, 요청/디버깅용 복제 식별자 |
| `entity_type` | `varchar(40)` | not null, 예: `memo`, `note`, `archive` |
| `entity_id` | `uuid` | not null |
| `operation` | `varchar(20)` | not null, allowed: `upsert`, `delete` |
| `payload` | `jsonb` | not null, tombstone도 최소 메타데이터 포함 |
| `updated_at` | `timestamptz` | not null, 클라이언트 논리 시각 |
| `deleted_at` | `timestamptz` | null, 삭제 이벤트인 경우 set |
| `recorded_at` | `timestamptz` | not null, default `now()`, 서버 수신 시각 |
| `created_at` | `timestamptz` | not null, default `now()` |

인덱스 / 제약:

- primary key on `id`
- unique index on `event_id`
- index on `user_id, recorded_at, event_id`
- index on `user_id, entity_type, entity_id, updated_at desc, recorded_at desc`
- index on `device_pk, recorded_at`
- check: `operation in ('upsert', 'delete')`
- check: `operation = 'delete'` 인 경우 `deleted_at is not null`
- check: `operation = 'upsert'` 인 경우 `deleted_at is null`

정렬 규칙:

- pull 정렬 키는 `(recorded_at asc, event_id asc)`다.
- 동일 `recorded_at` 충돌 시 `event_id`로 tie-break 한다.

LWW 판정 규칙:

- 동일 `(user_id, entity_type, entity_id)`에 대해 `updated_at`이 더 큰 이벤트가 우선한다.
- `updated_at`이 같으면 `recorded_at`이 더 늦은 이벤트가 우선한다.
- 그래도 같으면 `event_id` 문자열 순서를 tie-break로 사용한다.

관계:

- `users (1) -> (N) sync_events`
- `devices (1) -> (N) sync_events`

## 동작 계약

- push 전에 인증과 device 유효성 검증을 수행한다.
- 중복 `event_id`는 멱등하게 처리한다.
- pull은 요청한 사용자 자신의 이벤트만 반환한다.
- 자기 자신이 방금 보낸 이벤트도 다른 디바이스 관점에서는 pull 대상이 된다.
- 현재 요청 디바이스가 직전에 push한 이벤트를 같은 디바이스에 다시 내려줄지 여부는 서비스 정책으로 결정하되, v1 기본값은 `포함`이다.
- 만료된 cursor는 전체 재동기화가 필요하다는 신호를 반환한다.

## 에러

- `INVALID_DEVICE`
- `DUPLICATE_EVENT`
- `CURSOR_EXPIRED`
- `EVENT_PAYLOAD_INVALID`
- `SYNC_FORBIDDEN`
