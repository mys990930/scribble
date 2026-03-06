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
| signIn(email, password) | 로그인 |
| refresh(refreshToken) | 토큰 갱신 |
| signOut(accessToken) | 로그아웃 |

## 구현체 정책

- `ApiAuthService`: 실제 백엔드(`auth-session`) 연동
- `MockAuthService`: 로컬 개발/테스트용 가짜 인증
  - 고정 계정으로 성공 시나리오 제공
  - 서버 없이 Auth Gate / Login / Settings(SignOut) 흐름 검증 가능

## Usecases

| 이름 | 입력 | 출력 |
|---|---|---|
| RestoreSession | — | AuthState |
| SignIn | email, password | AuthState |
| SignOut | — | void |
