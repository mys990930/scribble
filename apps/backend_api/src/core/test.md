# core test

## 필수 검증

- 필수 환경 변수가 없으면 앱이 시작되지 않는다.
- 잘못된 DB URL이면 세션 초기화에 실패한다.
- AppError가 HTTP 응답 포맷으로 일관되게 변환된다.
- request-id가 모든 에러 응답에 포함된다.
- 인증 dependency는 만료된 토큰을 거부한다.
- cursor 파서는 변조된 값을 거부한다.
