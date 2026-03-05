# share-intent test

## handleIncoming
- text만 수신 → SharedContent.rawText=text로 HandleShare 호출
- url만 수신 → SharedContent.rawText=url로 HandleShare 호출
- text+url 수신 → 조합된 rawText로 HandleShare 호출
- fileUris만 수신 → URI 줄 목록 rawText로 HandleShare 호출
- mixed(text+url+fileUris) → 순서 규칙대로 조합된 rawText로 HandleShare 호출
- category 미입력 불가(호출자에서 필수 전달)
- 카테고리 선택 이전 단계에서는 HandleShare 호출 없음(미저장)

## parseFromPlatform
- raw.type=text/url/image/file/mixed 파싱 성공
- raw.type 누락 시 필드 조합으로 type 추론
- 미지원 type 문자열 → `SHARE_INTENT_UNSUPPORTED_TYPE`

## 실패 케이스
- text/url/fileUris 모두 빈값 → `SHARE_INTENT_EMPTY_PAYLOAD`

## 회귀 케이스
- 공백/개행 포함 text 정상 trim/전달
- 매우 긴 text에서도 HandleShare가 1회만 호출됨
