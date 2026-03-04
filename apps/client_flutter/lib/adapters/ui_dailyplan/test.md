# ui-dailyplan test

## DailyPlanScreen
- 플랜 있는 날 선택 → 타임라인 표시
- 플랜 없는 날 → 빈 상태
- 날짜 변경 → planForSelectedDayProvider 갱신

## WeeklySelector
- 좌우 탐색 → selectedDateProvider 변경
- 오늘 강조 표시

## 경계 케이스
- 루틴 0개인 플랜 → 빈 타임라인
- 루틴 겹침 → 둘 다 표시
