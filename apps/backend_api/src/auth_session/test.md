# auth_session test

## 성공 케이스

- 신규 사용자가 계정을 만들 수 있다.
- 올바른 자격 증명으로 로그인하면 access / refresh token이 발급된다.
- 유효한 refresh token으로 토큰 회전이 가능하다.
- `/auth/me`는 현재 사용자 정보를 반환한다.
- 로그아웃하면 해당 세션이 무효화된다.

## 실패 케이스

- 중복 이메일로 가입할 수 없다.
- 잘못된 비밀번호로 로그인할 수 없다.
- 만료된 refresh token으로 갱신할 수 없다.
- revoke된 세션으로 갱신할 수 없다.
- access token 없이 보호 엔드포인트를 호출할 수 없다.
