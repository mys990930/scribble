# auth-session contracts

## API

| 메서드 | 경로 | 설명 |
|---|---|---|
| POST | /auth/register | 계정 생성 |
| POST | /auth/login | 로그인 → 토큰 반환 |
| POST | /auth/refresh | 토큰 갱신 |
| POST | /auth/logout | 세션 무효화 |

## DTO

### LoginRequest
| 필드 | 타입 |
|---|---|
| email | String |
| password | String |

### TokenResponse
| 필드 | 타입 |
|---|---|
| accessToken | String |
| refreshToken | String |
| expiresIn | int (초) |

## 에러

| 코드 | HTTP | 설명 |
|---|---|---|
| AUTH_INVALID_CREDENTIALS | 401 | 잘못된 인증 정보 |
| AUTH_TOKEN_EXPIRED | 401 | 토큰 만료 |
| AUTH_USER_EXISTS | 409 | 이미 존재하는 계정 |
