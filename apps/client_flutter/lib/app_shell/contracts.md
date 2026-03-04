# app-shell contracts

## 라우트

| 경로 | 화면 |
|---|---|
| / | HomeScreen |
| /daily-plan | DailyPlanScreen |
| /calendar | CalendarScreen |
| /note | NoteScreen |
| /memo | MemoScreen |

## DI (ProviderScope)

- databaseProvider → AppDatabase 싱글턴
- 각 repoProvider → Database 기반 Repository 주입
- 각 usecaseProvider → (향후 usecase 클래스 주입)

## _WidgetSyncGate

- app resume 시 consumePendingMemo + syncWidget
- activeMemosProvider listen → 변경 시 자동 syncWidget
- 5분 주기 타이머 syncWidget
