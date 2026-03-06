# ui-settings

## 목표

앱 설정 화면을 제공한다.

## 책임

- 설정 화면 렌더링
- 알림/동기화/테마 항목 토글 UI
- 저장 액션을 settings-usecases로 위임

## 비책임

- 설정 저장 로직 구현 → `settings-usecases`
- 인증 로그아웃 로직 구현 → `auth-usecases`

## 의존 방향

```
ui_settings → settings_usecases, auth_usecases, shared/ui
ui_settings ← app_shell, ui_main (route target)
```
