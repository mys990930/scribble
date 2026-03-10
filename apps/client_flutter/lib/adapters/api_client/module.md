# api-client

## 목표

백엔드 API와의 HTTP 통신을 담당한다.
웹 플랫폼에서는 SQLite 대신 이 모듈의 Repository 구현을 사용한다.

## 책임

- `ApiAuthService` 구현 (`AuthService`)
- `ApiDeviceRegistryService` 구현 (디바이스 등록 bootstrap)
- SyncRemote 인터페이스 구현 (push/pull) — 네이티브 동기화용
- `ApiMemoRepository` 구현 (`MemoRepository`) — 웹 플랫폼에서 서버 직접 CRUD
- 인증 토큰 첨부 (auth-session 연계)
- sync 요청에 `X-Device-Id` 헤더 첨부
- HTTP 에러 → AppError 변환
- 디바이스 등록 API 호출

## 비책임

- 동기화 오케스트레이션 로직 → `sync`
- Memo 오케스트레이션(정렬/알람 판정) → `memo-usecases`
- 로컬 저장 → `storage-sqlite`

## 의존 방향

```text
api_client -.implements.-> memo_usecases (MemoRepository)
api_client -.implements.-> auth_usecases (AuthService via ApiAuthService)
api_client -.implements.-> sync (SyncRemote)
api_client → memo_domain, shared/kernel
api_client →(HTTP)→ backend (sync-api, auth-session, device-registry)
```
