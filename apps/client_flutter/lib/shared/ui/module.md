# shared/ui

## 목표

전체 앱에서 공유하는 디자인 토큰, 테마, 공통 UI 위젯을 제공한다.

## 책임

- AppColors: 컬러 팔레트 정의 (bg, surface, primary/secondary/tertiary, semantic 등)
- AppTheme (dotsTheme): Material ThemeData 구성
- RoutinePalette: Quick Tag 색상 매핑
- 공통 위젯: 앱 전역에서 재사용하는 기본 컴포넌트 (버튼, 카드 스타일 등)

## 비책임

- 기능별 화면/위젯 → 각 `ui-*` adapter
- 비즈니스 로직 → domain / usecases
- 플랫폼 위젯(홈 화면 위젯) → `widget-*` adapter

## 의존 모듈

- Flutter SDK (material.dart)
- `shared/kernel` — 필요 시 색상 코드 타입 참조

## 의존 방향

```
shared/ui → shared/kernel (optional), Flutter SDK
shared/ui ← 모든 ui-*, widget-*, app_shell
```
