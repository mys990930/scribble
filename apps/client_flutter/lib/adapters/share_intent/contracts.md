# share-intent contracts

## 입력 계약

### PlatformSharePayload

| 필드 | 타입 | 설명 |
|---|---|---|
| text | String? | 공유 원문 텍스트 |
| url | String? | 플랫폼이 별도 제공한 URL |
| sourceApp | String? | 공유 발신 앱 식별자(선택) |
| receivedAt | DateTime | 수신 시각 |

## 내부 변환 계약

### SharedContent 매핑

| SharedContent 필드 | 매핑 규칙 |
|---|---|
| rawText | `url != null`이면 `"{text}\n{url}"` 조합, 없으면 `text` |
| category | 호출자에서 전달한 선택 카테고리 또는 기본 카테고리 |

## 서비스 인터페이스

### ShareIntentAdapter

| 메서드 | 설명 |
|---|---|
| handleIncoming(PlatformSharePayload payload, {required String category}) → Future<void> | payload 수신 후 HandleShare 실행 |

## 에러

| 코드 | 설명 |
|---|---|
| `SHARE_INTENT_EMPTY_PAYLOAD` | text/url 모두 비어 있음 |
| `SHARE_INTENT_UNSUPPORTED_TYPE` | 지원하지 않는 공유 타입 |
