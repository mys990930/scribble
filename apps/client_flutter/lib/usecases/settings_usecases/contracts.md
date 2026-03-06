# settings-usecases contracts

## AppSettings

| 필드 | 타입 | 설명 |
|---|---|---|
| notificationsEnabled | bool | 알림 활성화 |
| syncOnCellular | bool | 셀룰러 동기화 허용 |
| themeMode | String | system/light/dark |

## SettingsStore (abstract)

| 메서드 | 설명 |
|---|---|
| read() | 현재 설정 조회 |
| save(AppSettings) | 설정 저장 |
