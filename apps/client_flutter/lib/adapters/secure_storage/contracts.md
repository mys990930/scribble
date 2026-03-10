# secure-storage contracts

## Stored Keys

| 키 | 설명 |
|---|---|
| auth.access_token | access token |
| auth.refresh_token | refresh token |
| auth.user_id | 사용자 ID |
| auth.expires_at | 만료 시각(ISO8601) |
| device.id | 설치 단위 안정적 디바이스 ID |

## 구현 계약

- 저장 실패 시 예외 throw
- read에서 일부 필드 누락 시 null 반환 (손상 데이터 취급)
- clear는 idempotent
- 네이티브 구현은 `flutter_secure_storage`를 사용한다
- `device.id`는 최초 1회 생성 후 재사용한다
- 웹 구현은 localStorage를 사용하며 키/값 형식은 네이티브와 동일 계약을 따른다
