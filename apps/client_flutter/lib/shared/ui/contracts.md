# shared/ui contracts

## AppColors

| 토큰 | HEX | 용도 |
|---|---|---|
| bg | #142232 | 배경 |
| surface | #35465C | 카드/서피스 |
| primary | #E6535E | 주 강조 (빨강) |
| secondary | #FCD364 | 부 강조 (노랑) |
| tertiary | #6BBC8A | 3차 강조 (초록) |
| accentWarm | #F09661 | 따뜻한 액센트 |
| accentCool | #58C3EC | 차가운 액센트 |
| accentPurple | #746DA7 | 보라 액센트 |
| textPrimary | #FFFFFF | 본문 텍스트 |
| textSecondary | #DCE3EA | 보조 텍스트 |
| textMuted | #AEB9C6 | 비활성 텍스트 |
| overdue | primary | 기한 초과 |
| warning | secondary | 경고 |
| success | tertiary | 성공 |

## dotsTheme (ThemeData)

- brightness: dark
- scaffoldBackgroundColor: bg
- colorScheme: primary/secondary/surface 매핑
- cardTheme: surface, elevation 0, borderRadius 16
- appBarTheme: bg 배경, elevation 0
- elevatedButton: primary, borderRadius 16
- FAB: primary

## RoutinePalette

| 태그 | 색상 | 소스 토큰 |
|---|---|---|
| Work | #E6535E | primary |
| Rest | #6BBC8A | tertiary |
| Sleep | #58C3EC | accentCool |

## 공통 위젯 (예정)

v1 초기에는 AppColors + dotsTheme만 제공.
공통 위젯은 UI 개발 중 반복 패턴 발견 시 추출.
