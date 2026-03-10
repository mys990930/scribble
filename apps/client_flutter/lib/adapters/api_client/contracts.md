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

모든 sync 요청은 아래 헤더를 포함한다.

- `Authorization: Bearer <access_token>`
- `X-Device-Id: <deviceId>`

| 메서드 | 경로 | 설명 |
|---|---|---|
| POST | /auth/login | 로그인 |
| POST | /auth/refresh | 토큰 갱신 |
| POST | /devices | 디바이스 등록 |
| POST | /sync/push | 로컬 변경 전송 |
| GET | /sync/pull | 서버 변경 수신 |

네이티브 흐름:
- 로그인 성공 후 `/devices` 등록을 먼저 수행한다.
- sync 요청은 등록된 활성 디바이스 컨텍스트를 전제로 한다.
