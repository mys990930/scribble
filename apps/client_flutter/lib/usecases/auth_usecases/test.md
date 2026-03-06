# auth-usecases test

## RestoreSession
- 저장 세션 없음 → unauthenticated
- 저장 세션 유효 → authenticated
- 저장 세션 만료 + refresh 성공 → authenticated (세션 갱신)
- 저장 세션 만료 + refresh 실패 → unauthenticated (세션 제거)

## SignIn
- 정상 계정 → authenticated + 세션 저장
- 인증 실패 → unauthenticated + 에러 반환
- MockAuthService 모드에서 고정 테스트 계정 로그인 성공
- MockAuthService 모드에서 잘못된 계정 로그인 실패

## SignOut
- 로컬 세션 제거
- 원격 signOut 실패 시에도 로컬 세션은 제거 (best effort)
- MockAuthService 모드에서도 동일하게 로컬 세션 제거
