# auth-session test

## register
- 정상 → 201, 계정 생성
- 중복 email → AUTH_USER_EXISTS

## login
- 정상 → 토큰 반환
- 잘못된 비밀번호 → AUTH_INVALID_CREDENTIALS

## refresh
- 유효한 refreshToken → 새 accessToken
- 만료된 refreshToken → AUTH_TOKEN_EXPIRED

## logout
- 정상 → 세션 무효화
- 이후 accessToken 사용 → 401
