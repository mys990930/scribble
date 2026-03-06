# app-shell contracts

## 라우트

| 경로 | 화면 | 설명 |
|---|---|---|
| /auth-gate | AuthGateScreen | 앱 시작 시 세션 복구 및 분기 (초기 라우트) |
| /auth/login | LoginScreen | 로그인 화면 |
| /main | MainScreen | 인증 후 메인 허브 |
| /memo | MemoScreen | 메모 기능 |
| /archive | ArchiveScreen | 아카이브 기능 |
| /settings | SettingsScreen | 설정 화면 |

Auth Gate 분기:
- 세션 유효: `/main` 이동
- 세션 무효: `/auth/login` 이동

## DI (app_shell/di/)

### memoServiceProvider
- 타입: `Provider<MemoService>`
- 네이티브: `MemoServiceImpl(DriftMemoRepository)`
- 웹: `MemoServiceImpl(ApiMemoRepository)`

### authUsecaseProvider
- 타입: `Provider<AuthUsecase>`
- 네이티브/웹: `AuthUsecaseImpl(AuthService, AuthSessionStore)`
- AuthService 구현체:
  - `ApiAuthService` (실제 백엔드)
  - `MockAuthService` (로컬 개발/테스트용)

### authSessionStoreProvider
- 타입: `Provider<AuthSessionStore>`
- 네이티브: `SecureAuthSessionStore`
- 웹: `LocalStorageAuthSessionStore`

### settingsStoreProvider (추가 예정)
- 타입: `Provider<SettingsStore>`

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
