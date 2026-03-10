# device_registry contracts

## 엔드포인트

### `POST /devices`

새 디바이스를 등록한다.

Request:

```json
{
  "device_id": "client-generated-id",
  "platform": "ios",
  "name": "My iPhone",
  "app_version": "1.0.0"
}
```

Response `201`:

```json
{
  "device": {
    "id": "uuid",
    "device_id": "client-generated-id",
    "platform": "ios",
    "name": "My iPhone",
    "is_active": true
  }
}
```

### `GET /devices`

현재 사용자 디바이스 목록을 조회한다.

### `DELETE /devices/{device_id}`

디바이스를 해제한다.

## 내부 서비스 계약

- `validate_active_device(user_id, device_id)`
- `touch_last_sync_at(user_id, device_id, synced_at)`
- `enforce_device_limit(user_id)`

## DTO

- `RegisterDeviceRequest`
- `DeviceResponse`
- `DeviceListResponse`
- `DeactivateDeviceResponse`

## 저장 계약

### `devices`

사용자별 등록 디바이스 테이블.

| 컬럼 | 타입 | 제약 / 설명 |
|---|---|---|
| `id` | `uuid` | PK |
| `user_id` | `uuid` | not null, FK -> `users.id` |
| `device_id` | `varchar(128)` | not null, 클라이언트가 생성한 안정적 식별자 |
| `platform` | `varchar(20)` | not null, allowed: `ios`, `android`, `windows`, `macos`, `linux`, `web` |
| `name` | `varchar(120)` | not null |
| `app_version` | `varchar(40)` | null |
| `last_ip` | `inet` | null |
| `last_user_agent` | `text` | null |
| `registered_at` | `timestamptz` | not null, default `now()` |
| `last_seen_at` | `timestamptz` | null |
| `last_sync_at` | `timestamptz` | null |
| `deactivated_at` | `timestamptz` | null |
| `created_at` | `timestamptz` | not null, default `now()` |
| `updated_at` | `timestamptz` | not null, default `now()` |

인덱스 / 제약:

- unique index on `user_id, device_id`
- index on `user_id, deactivated_at`
- index on `user_id, last_sync_at`
- check: `deactivated_at is null or deactivated_at >= registered_at`

상태 규칙:

- `deactivated_at is null` 이면 활성 디바이스다.
- 같은 `(user_id, device_id)` 조합은 하나의 row만 가진다.
- 해제된 디바이스를 같은 `device_id`로 다시 등록하면 새 row를 만들지 않고 기존 row를 재활성화한다.
- 이미 활성인 동일 `device_id`를 다시 등록하면 `DEVICE_ALREADY_REGISTERED`다.

관계:

- `users (1) -> (N) devices`

## 요청 메타데이터 규칙

- 등록 시 `last_seen_at`은 서버 현재 시각으로 기록한다.
- 요청에서 client IP를 얻을 수 있으면 `last_ip`를 기록한다.
- `User-Agent` 헤더가 있으면 `last_user_agent`를 기록한다.
- IP 또는 `User-Agent`를 얻지 못하면 해당 컬럼은 `null`을 허용한다.

## 에러

- `DEVICE_ALREADY_REGISTERED`
- `DEVICE_LIMIT_EXCEEDED`
- `DEVICE_NOT_FOUND`
- `DEVICE_INACTIVE`
- `DEVICE_FORBIDDEN`
