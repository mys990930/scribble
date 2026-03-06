# secure-storage

## 목표

플랫폼별 저장소를 통해 인증 세션을 저장한다.
- 네이티브: secure storage
- 웹: localStorage

## 책임

- `AuthSessionStore` 구현
- 네이티브에서 access/refresh token 안전 저장/조회
- 웹에서 localStorage 기반 세션 저장/조회
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
