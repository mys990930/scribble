# sync-api

## 목표

클라이언트 동기화 요청을 처리하는 서버 엔드포인트를 담당한다.

## 책임

- push 수신: 클라이언트 변경 이벤트 저장, 다른 디바이스 대상 배포
- pull 응답: 커서 이후 변경분 반환
- LWW 충돌 해결 (서버 측)
- Tombstone 관리

## 비책임

- 인증 → `auth-session`
- 디바이스 검증 → `device-registry`
- 클라이언트 측 동기화 → client `sync` 모듈

## 의존 모듈

- `auth-session` — 인증
- `device-registry` — deviceId 검증

## 의존 방향

```
sync_api → auth_session, device_registry
sync_api ←(HTTP)← api_client
```
