# ui-main

## 목표

앱의 메인 허브 화면(UI 진입 포털)을 제공한다.

## 책임

- 메인 홈 화면 렌더링
- 각 기능 화면(memo/calendar/dailyplan/note/archive/settings) 진입 액션 제공
- 인증 상태가 유효한 사용자만 접근하도록 auth gate 이후 화면 제공

## 비책임

- 인증 상태 판정/복구 로직 → `auth-usecases`
- 실제 기능 비즈니스 로직 → 각 `*-usecases`
- 라우팅 초기 분기 → `app-shell`

## 의존 방향

```
ui_main → shared/ui
ui_main ← app_shell (route target)
```
