# secure-storage contracts

## Stored Keys

| 키 | 설명 |
|---|---|
| auth.access_token | access token |
| auth.refresh_token | refresh token |
| auth.user_id | 사용자 ID |
| auth.expires_at | 만료 시각(ISO8601) |

## 구현 계약

- 저장 실패 시 예외 throw
- read에서 일부 필드 누락 시 null 반환 (손상 데이터 취급)
- clear는 idempotent
- 웹 구현은 localStorage를 사용하며 키/값 형식은 네이티브와 동일 계약을 따른다
