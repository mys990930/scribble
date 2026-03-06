# secure-storage

## 목표

민감한 인증 토큰/세션 정보를 안전하게 저장한다.

## 책임

- `AuthSessionStore` 구현
- access/refresh token 암호화 저장/조회
- 로그아웃/세션 만료 시 저장 데이터 제거

## 비책임

- 인증 API 호출 → `api-client`
- 인증 플로우 오케스트레이션 → `auth-usecases`
- 로그인 UI → `ui-auth`

## 의존 방향

```
secure_storage -.implements.-> auth_usecases (AuthSessionStore)
secure_storage ← app_shell/di (platform wiring)
```
