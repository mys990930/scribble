# device-registry contracts

## API

| 메서드 | 경로 | 설명 |
|---|---|---|
| POST | /devices/register | 디바이스 등록 |
| GET | /devices | 디바이스 목록 |
| DELETE | /devices/:id | 디바이스 해제 |

## DTO

### DeviceRegisterRequest
| 필드 | 타입 |
|---|---|
| deviceId | String (UUID) |
| platform | String (android/ios/web/windows) |
| name | String |

### Device
| 필드 | 타입 |
|---|---|
| id | String |
| platform | String |
| name | String |
| registeredAt | DateTime |
| lastSyncAt | DateTime? |

## 에러

| 코드 | HTTP | 설명 |
|---|---|---|
| DEVICE_ALREADY_REGISTERED | 409 | 이미 등록된 deviceId |
| DEVICE_NOT_FOUND | 404 | 존재하지 않는 디바이스 |
| DEVICE_LIMIT_EXCEEDED | 403 | 최대 디바이스 수 초과 |
