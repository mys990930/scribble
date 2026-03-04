# ui-dailyplan contracts

## Provider

| Provider | 타입 | 설명 |
|---|---|---|
| allPlansProvider | FutureProvider\<List\<DailyPlan\>\> | 전체 플랜 |
| selectedDateProvider | StateProvider\<DateTime\> | 선택된 날짜 |
| planForSelectedDayProvider | Provider\<DailyPlan?\> | 선택일의 플랜 |

## 화면

### DailyPlanScreen
- 상단: WeeklySelector (날짜 탐색)
- 본문: PlanTimeline (루틴 타임라인)
- 플랜 없는 날 → 빈 상태 메시지
