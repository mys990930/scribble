# device-registry

## 목표

사용자별 디바이스 등록 및 관리를 담당한다.

## 책임

- 디바이스 등록 (deviceId, platform, name)
- 디바이스 목록 조회
- 디바이스 해제
- 동기화 시 deviceId 검증

## 비책임

- 인증 → `auth-session`
- 동기화 로직 → `sync-api`

## 의존 모듈

- `auth-session` — 인증 검증

## 의존 방향

```
device_registry → auth_session (인증)
device_registry ← sync_api (deviceId 검증)
```
