# auth_session contracts

## 엔드포인트

### `POST /auth/register`

계정을 생성한다.

Request:

```json
{
  "email": "user@example.com",
  "password": "plain-password"
}
```

Response `201`:

```json
{
  "user": {
    "id": "uuid",
    "email": "user@example.com"
  }
}
```

### `POST /auth/login`

로그인하고 토큰 쌍을 발급한다.

### `POST /auth/refresh`

refresh token을 검증하고 새 토큰 쌍을 발급한다.

### `POST /auth/logout`

현재 refresh session을 무효화한다.

### `GET /auth/me`

현재 인증된 사용자 정보를 반환한다.

## DTO

- `RegisterRequest`
- `LoginRequest`
- `RefreshRequest`
- `TokenPairResponse`
- `CurrentUserResponse`
- `SessionInfo`

## 저장 계약

### `users`

계정 기본 테이블.

| 컬럼 | 타입 | 제약 / 설명 |
|---|---|---|
| `id` | `uuid` | PK |
| `email` | `citext` | not null, unique |
| `password_hash` | `text` | not null, `pwdlib` 해시 저장 |
| `status` | `varchar(20)` | not null, default `'active'`, allowed: `active`, `disabled` |
| `last_login_at` | `timestamptz` | null |
| `created_at` | `timestamptz` | not null, default `now()` |
| `updated_at` | `timestamptz` | not null, default `now()` |
| `deleted_at` | `timestamptz` | null |

인덱스 / 제약:

- unique index on `email`
- index on `status`
- `deleted_at`를 사용하더라도 이메일 재사용 정책은 v1에서 허용하지 않는다. 따라서 unique는 전체 행 기준으로 유지한다.

### `auth_sessions`

refresh session 저장 테이블. access token은 저장하지 않는다.

| 컬럼 | 타입 | 제약 / 설명 |
|---|---|---|
| `id` | `uuid` | PK, 세션 식별자 |
| `user_id` | `uuid` | not null, FK -> `users.id` |
| `refresh_token_hash` | `text` | not null, unique |
| `session_version` | `integer` | not null, default `1` |
| `issued_at` | `timestamptz` | not null |
| `expires_at` | `timestamptz` | not null |
| `last_used_at` | `timestamptz` | null |
| `revoked_at` | `timestamptz` | null |
| `revoke_reason` | `varchar(50)` | null |
| `created_by_ip` | `inet` | null |
| `user_agent` | `text` | null |
| `created_at` | `timestamptz` | not null, default `now()` |
| `updated_at` | `timestamptz` | not null, default `now()` |

인덱스 / 제약:

- unique index on `refresh_token_hash`
- index on `user_id, revoked_at`
- index on `user_id, expires_at`
- check: `expires_at > issued_at`
- check: `revoked_at is null or revoked_at >= issued_at`

관계:

- `users (1) -> (N) auth_sessions`

## 라이브러리 계약

- 비밀번호 검증/해싱은 `pwdlib`를 사용한다.
- JWT 발급/검증은 `PyJWT`를 사용한다.
- access token은 짧은 TTL을 갖고 서버 저장 없이 검증한다.
- refresh token은 DB 세션 상태와 함께 검증한다.

## 토큰 계약

### access token claim

- `sub`: user id
- `sid`: auth session id
- `type`: `access`
- `exp`
- `iat`

### refresh token claim

- `sub`: user id
- `sid`: auth session id
- `type`: `refresh`
- `ver`: `session_version`
- `exp`
- `iat`

## 에러

- `EMAIL_ALREADY_EXISTS`
- `INVALID_CREDENTIALS`
- `SESSION_NOT_FOUND`
- `SESSION_REVOKED`
- `TOKEN_EXPIRED`
- `TOKEN_INVALID`
- `USER_DISABLED`
