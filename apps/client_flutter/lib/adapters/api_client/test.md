# api-client test

## push
- 정상 응답 → 성공
- 401 → API_UNAUTHORIZED
- 네트워크 실패 → API_NETWORK_ERROR

## pull
- 변경 2건 응답 → PullResult 파싱
- 빈 응답 → 빈 changes + 커서

## 인증
- 토큰 만료 → 자동 refresh 시도
- refresh 실패 → API_UNAUTHORIZED

## 경계 케이스
- 대용량 payload → 정상 처리
- 타임아웃 → API_NETWORK_ERROR
