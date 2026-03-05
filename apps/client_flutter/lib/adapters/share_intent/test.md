# share-intent test

## handleIncoming
- text만 수신 → SharedContent.rawText=text로 HandleShare 호출
- url만 수신 → SharedContent.rawText=url로 HandleShare 호출
- text+url 수신 → 조합된 rawText로 HandleShare 호출
- category 미입력 불가(호출자에서 필수 전달)

## 실패 케이스
- text/url 모두 빈값 → `SHARE_INTENT_EMPTY_PAYLOAD`
- 미지원 공유 타입(payload 파싱 불가) → `SHARE_INTENT_UNSUPPORTED_TYPE`

## 회귀 케이스
- 공백/개행 포함 text 정상 trim/전달
- 매우 긴 text에서도 HandleShare가 1회만 호출됨
