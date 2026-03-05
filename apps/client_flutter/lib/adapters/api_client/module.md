# api-client

## 목표

백엔드 API와의 HTTP 통신을 담당한다.
웹 플랫폼에서는 SQLite 대신 이 모듈이 직접 CRUD를 수행한다.

## 책임

- SyncRemote 인터페이스 구현 (push/pull) — 네이티브 동기화용
- **ApiMemoService 구현 (MemoService)** — 웹 플랫폼에서 서버 직접 CRUD
- 인증 토큰 첨부 (auth-session 연계)
- HTTP 에러 → AppError 변환
- 디바이스 등록 API 호출

## 비책임

- 동기화 로직 → `sync`
- 인증 로직 → backend `auth-session`
- 로컬 저장 → `storage-sqlite`

## 의존 모듈

- `memo-usecases` — MemoService 인터페이스 (implements)
- `memo-domain` — Memo 엔티티 (DTO 변환)
- `sync` — SyncRemote 인터페이스 (implements)
- `shared/kernel` — AppError

## 의존 방향

```
api_client -.implements.-> memo_usecases (MemoService)
api_client -.implements.-> sync (SyncRemote)
api_client → memo_domain, shared/kernel
api_client →(HTTP)→ backend (sync-api, auth-session, device-registry)
```
