# ui-auth

## 목표

로그인/세션 복구/재인증 화면을 제공한다.

## 책임

- AuthGateScreen: 앱 시작 시 세션 복구 상태 표시 및 분기
- LoginScreen: 사용자 인증 입력/요청
- 세션 만료 시 재로그인 UX 제공

## 비책임

- 토큰 저장/세션 복구 로직 자체 → `auth-usecases`
- 라우팅 테이블 정의 → `app-shell`

## 의존 방향

```
ui_auth → auth_usecases, shared/ui
ui_auth ← app_shell (route target)
```
