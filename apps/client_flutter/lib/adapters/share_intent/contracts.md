# share-intent contracts

## 입력 계약

### PlatformSharePayload

| 필드 | 타입 | 설명 |
|---|---|---|
| type | SharePayloadType | 공유 payload 타입 (`text`, `url`, `image`, `file`, `mixed`) |
| text | String? | 공유 원문 텍스트 |
| url | String? | 플랫폼이 별도 제공한 URL |
| fileUris | List\<String\> | 공유된 파일 URI 목록 |
| mimeType | String? | 대표 MIME 타입 (선택) |
| sourceApp | String? | 공유 발신 앱 식별자(선택) |
| receivedAt | DateTime | 수신 시각 |

## 내부 변환 계약

### SharedContent 매핑

| SharedContent 필드 | 매핑 규칙 |
|---|---|
| rawText | 아래 우선순위로 조합: `text`, `url`, `fileUris` |
| category | 호출자에서 전달한 선택 카테고리 또는 기본 카테고리 |

### rawText 조합 규칙

1. `text`가 있으면 첫 줄 블록으로 사용
2. `url`이 있으면 다음 줄에 추가
3. `fileUris`가 있으면 각 URI를 줄 단위로 추가
4. 최종 조합 결과가 비어 있으면 에러

## 서비스 인터페이스

### ShareIntentAdapter

| 메서드 | 설명 |
|---|---|
| handleIncoming(PlatformSharePayload payload, {required String category}) → Future<void> | payload 수신 후 HandleShare 실행 |
| parseFromPlatform(Map\<String, dynamic\> raw) → PlatformSharePayload | 플랫폼 raw payload를 표준 계약으로 파싱 |

## MethodChannel

- 채널명: `scribble/share_intent`
- `consumePendingShare()`: 네이티브 런처에 저장된 공유 payload를 1회 소비

## 에러

| 코드 | 설명 |
|---|---|
| `SHARE_INTENT_EMPTY_PAYLOAD` | text/url/fileUris 모두 비어 있음 |
| `SHARE_INTENT_UNSUPPORTED_TYPE` | 지원하지 않는 공유 타입 |
