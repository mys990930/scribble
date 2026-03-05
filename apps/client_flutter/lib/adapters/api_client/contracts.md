# api-client contracts

## ApiMemoRepository (implements MemoRepository)

웹 플랫폼 전용. CRUD를 서버 API에 직접 위임한다.

| 메서드 | HTTP | 설명 |
|---|---|---|
| listActive | GET /api/memos?resolved=false | 미완료 메모 목록 |
| listResolved | GET /api/memos?resolved=true | 완료 메모 목록 |
| getById | GET /api/memos/:id | 단건 조회 |
| upsert | POST/PUT /api/memos | 메모 생성/수정 |
| delete | DELETE /api/memos/:id | 메모 삭제 |
| getMaxUrgentOrder | - | 서버 정책 확정 후 구현 |
| getMinUrgentOrder | - | 서버 정책 확정 후 구현 |

## 동기화 엔드포인트 (네이티브용)

| 메서드 | 경로 | 설명 |
|---|---|---|
| POST | /auth/login | 로그인 |
| POST | /auth/refresh | 토큰 갱신 |
| POST | /devices/register | 디바이스 등록 |
| POST | /sync/push | 로컬 변경 전송 |
| POST | /sync/pull | 서버 변경 수신 |
