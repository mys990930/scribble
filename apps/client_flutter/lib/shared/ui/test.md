# shared/ui test

## AppColors
- 각 색상 상수 → null 아님, Color 타입
- semantic 색상(overdue/warning/success) → 대응하는 primary/secondary/tertiary와 동일

## dotsTheme
- brightness == dark
- scaffoldBackgroundColor == AppColors.bg
- colorScheme.primary == AppColors.primary
- cardTheme.shape borderRadius == 16

## RoutinePalette
- work → 0xFFE6535E
- rest → 0xFF6BBC8A
- sleep → 0xFF58C3EC
- fromTokens() == 기본 생성자 값

## 경계 케이스
- dotsTheme을 MaterialApp에 적용 → 빌드 에러 없음
