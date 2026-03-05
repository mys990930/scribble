# app-shell contracts

## 라우트

| 경로 | 화면 |
|---|---|
| / | HomeScreen |
| /memo | MemoScreen |

## DI (app_shell/di/)

### memoServiceProvider
- 타입: `Provider<MemoService>`
- 네이티브 (`di_native.dart`): `DriftMemoService(AppDatabase)` — SQLite 기반
- 웹 (`di_web.dart`): `ApiMemoService()` — 서버 API 기반
- 조건부 import로 컴파일 타임에 결정

### 향후 추가 예정
- dailyPlanServiceProvider
- calendarServiceProvider
- noteServiceProvider
- archiveServiceProvider

## _WidgetSyncGate

- `kIsWeb == true` → 모든 MethodChannel/타이머 비활성
- 네이티브:
  - app resume 시 consumePendingMemo + syncWidget
  - activeMemosProvider listen → 변경 시 자동 syncWidget
  - 5분 주기 타이머 syncWidget
