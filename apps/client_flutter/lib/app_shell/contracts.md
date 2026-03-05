# app-shell contracts

## 라우트

| 경로 | 화면 |
|---|---|
| / | HomeScreen |
| /memo | MemoScreen |
| /archive | ArchiveScreen |

## DI (app_shell/di/)

### memoServiceProvider
- 타입: `Provider<MemoService>`
- 네이티브 (`di_native.dart`): `MemoServiceImpl(DriftMemoRepository)`
- 웹 (`di_web.dart`): `MemoServiceImpl(ApiMemoRepository)`
- 조건부 import로 컴파일 타임에 결정

### shareIntentAdapterProvider
- 타입: `Provider<ShareIntentAdapter>`
- 네이티브: `MethodChannelShareIntentAdapter(MethodChannel('scribble/share_intent'), handleShare)`
- 웹: 미지원 에러 구현

## 앱 시작 공유 처리

- 앱 시작 시 `consumePendingShare()` 호출
- pending payload가 있으면 `ui-archive` 카테고리 선택 플로우로 전달
- 카테고리 확정 전에는 자동 저장하지 않음

## _WidgetSyncGate

- `kIsWeb == true` → 모든 MethodChannel/타이머 비활성
- 네이티브:
  - app start/resume 시 `consumePendingMemo + syncWidget`
  - activeMemosProvider listen → 변경 시 자동 syncWidget
  - 5분 주기 타이머 syncWidget
