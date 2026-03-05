# api-client contracts

## ApiMemoService (implements MemoService)

웹 플랫폼 전용. 모든 CRUD를 서버 API에 직접 위임한다.

| 메서드 | HTTP | 설명 |
|---|---|---|
| listActiveMemos | GET /api/memos?resolved=false | 미완료 메모 목록 |
| listResolvedMemos | GET /api/memos?resolved=true | 완료 메모 목록 |
| addMemo | POST /api/memos | 메모 추가 |
| updateMemo | PUT /api/memos/:id | 메모 수정 |
| toggleResolved | PATCH /api/memos/:id/resolve | 완료 토글 |
| deleteMemo | DELETE /api/memos/:id | 메모 삭제 |
| reorderActiveMemos | PUT /api/memos/reorder | 순서 변경 |

## 동기화 엔드포인트 (네이티브용)

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
