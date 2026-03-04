# api-client contracts

## 엔드포인트 (예정)

| 메서드 | 경로 | 설명 |
|---|---|---|
| POST | /auth/login | 로그인 |
| POST | /auth/refresh | 토큰 갱신 |
| POST | /devices/register | 디바이스 등록 |
| POST | /sync/push | 로컬 변경 전송 |
| POST | /sync/pull | 서버 변경 수신 |

## 에러 매핑

| HTTP 상태 | AppError 코드 |
|---|---|
| 401 | `API_UNAUTHORIZED` |
| 403 | `API_FORBIDDEN` |
| 404 | `API_NOT_FOUND` |
| 429 | `API_RATE_LIMITED` |
| 5xx | `API_SERVER_ERROR` |
| 네트워크 실패 | `API_NETWORK_ERROR` |
