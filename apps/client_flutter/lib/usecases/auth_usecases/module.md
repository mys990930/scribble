# auth-usecases

## 목표

인증 흐름을 오케스트레이션한다. (로그인, 로그아웃, 세션 복구)

## 책임

- 로그인/로그아웃 유스케이스
- 앱 시작 시 세션 복구(restoreSession)
- 현재 인증 상태(AuthState) 제공
- 토큰/세션 저장 인터페이스(`AuthSessionStore`) 정의
- 원격 인증 인터페이스(`AuthService`) 정의

## 비책임

- 로그인 화면 UI → `ui-auth`
- 토큰 실제 저장 구현 → `secure-storage` / 웹 저장소 adapter
- HTTP 인증 API 호출 구현 → `api-client`
- 라우팅 분기 → `app-shell`

## 의존 모듈

- `shared/kernel` — Result/AppError

## 의존 방향

```
auth_usecases → shared/kernel
auth_usecases ← ui_auth, app_shell/di
auth_usecases ← api_client, secure_storage (implements)
```
