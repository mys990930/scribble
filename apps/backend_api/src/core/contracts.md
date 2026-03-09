# core contracts

## 설정 계약

- `APP_ENV`
- `APP_HOST`
- `APP_PORT`
- `DATABASE_URL`
- `JWT_SECRET`
- `JWT_ALGORITHM`
- `ACCESS_TOKEN_TTL_MINUTES`
- `REFRESH_TOKEN_TTL_DAYS`
- `DEVICE_LIMIT_PER_USER`
- `SYNC_CURSOR_TTL_DAYS`

## 런타임 계약

- Python 실행/의존성 관리는 `uv` 기준으로 통일한다.
- API 프레임워크는 `FastAPI`다.
- ORM은 `SQLAlchemy 2.x` async ORM이다.
- DB 드라이버는 `asyncpg`다.
- migration은 `Alembic`으로만 관리한다.
- JWT는 `PyJWT`로 발급/검증한다.
- 비밀번호 해싱은 `pwdlib`로 처리한다.

## 공통 DB 규칙

### 타입 규칙

- PK는 기본적으로 `uuid`를 사용한다.
- 시각 필드는 모두 timezone-aware UTC `timestamptz`를 사용한다.
- enum이 필요한 필드는 PostgreSQL enum 또는 체크 제약으로 제한한다.
- JSON payload는 `jsonb`를 사용한다.
- email은 대소문자 비민감 비교를 위해 `citext`를 사용한다.

### 공통 컬럼 믹스인

모든 영속 모델은 필요에 따라 다음 공통 컬럼을 재사용한다.

- `id: uuid primary key`
- `created_at: timestamptz not null default now()`
- `updated_at: timestamptz not null default now()`
- `deleted_at: timestamptz null`

### 소프트 삭제 규칙

- `deleted_at is null` 이면 활성 레코드다.
- soft delete 대상이 아닌 테이블은 `deleted_at` 대신 전용 상태 컬럼을 사용해도 된다.
- unique 제약이 soft delete와 충돌할 경우 부분 인덱스를 우선 사용한다.

## 공통 에러 모델

- `UNAUTHORIZED`
- `FORBIDDEN`
- `NOT_FOUND`
- `VALIDATION_ERROR`
- `CONFLICT`
- `CURSOR_EXPIRED`
- `INTERNAL_ERROR`

응답 포맷 초안:

```json
{
  "error": {
    "code": "UNAUTHORIZED",
    "message": "Authentication is required",
    "request_id": "req_123"
  }
}
```

## 인증 dependency 계약

- `get_current_user()`
  - access token을 `PyJWT`로 검증하고 현재 사용자 식별자를 반환한다.
- `get_current_session()`
  - 필요 시 세션 식별자와 현재 사용자를 함께 반환한다.
- `get_current_device()`
  - sync-api에서 사용할 디바이스 컨텍스트를 반환한다.

## Cursor 계약

- cursor는 서버가 발급한 불투명 문자열이다.
- 내부적으로는 최소한 `recorded_at` + `event_id` 또는 동등한 정렬 키를 표현해야 한다.
- cursor는 사용자 범위를 넘어서 재사용될 수 없다.
- 만료된 cursor는 `CURSOR_EXPIRED`로 응답한다.
- v1에서는 별도 cursor 저장 테이블 없이 stateless cursor를 우선한다.
