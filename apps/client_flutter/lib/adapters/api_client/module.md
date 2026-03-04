# api-client

## 목표

백엔드 API와의 HTTP 통신을 담당한다.

## 책임

- SyncRemote 인터페이스 구현 (push/pull)
- 인증 토큰 첨부 (auth-session 연계)
- HTTP 에러 → AppError 변환
- 디바이스 등록 API 호출

## 비책임

- 동기화 로직 → `sync`
- 인증 로직 → backend `auth-session`
- 로컬 저장 → `storage-sqlite`

## 의존 모듈

- `sync` — SyncRemote 인터페이스 (implements)
- `shared/kernel` — AppError

## 의존 방향

```
api_client -.implements.-> sync (SyncRemote)
api_client → shared/kernel
api_client →(HTTP)→ backend (sync-api, auth-session, device-registry)
```
