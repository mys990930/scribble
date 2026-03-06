# auth-usecases contracts

## AuthState

| 값 | 설명 |
|---|---|
| unauthenticated | 세션 없음 |
| authenticated | 유효 세션 존재 |
| restoring | 세션 복구 중 |

## AuthSession

| 필드 | 타입 | 설명 |
|---|---|---|
| accessToken | String | 액세스 토큰 |
| refreshToken | String | 리프레시 토큰 |
| userId | String | 사용자 ID |
| expiresAt | DateTime | 만료 시각 |

## AuthSessionStore (abstract)

| 메서드 | 설명 |
|---|---|
| save(AuthSession) | 세션 저장 |
| read() | 세션 조회 |
| clear() | 세션 삭제 |

## AuthService (abstract)

| 메서드 | 설명 |
|---|---|
| signIn(email, password) | 원격 로그인 |
| refresh(refreshToken) | 토큰 갱신 |
| signOut(accessToken) | 원격 로그아웃 |

## Usecases

| 이름 | 입력 | 출력 |
|---|---|---|
| RestoreSession | — | AuthState |
| SignIn | email, password | AuthState |
| SignOut | — | void |
