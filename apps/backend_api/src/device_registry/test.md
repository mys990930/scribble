# device-registry test

## register
- 정상 → 201
- 중복 deviceId → DEVICE_ALREADY_REGISTERED
- 디바이스 5대 초과 → DEVICE_LIMIT_EXCEEDED

## list
- 등록 디바이스 3대 → 3개 반환
- 0대 → 빈 배열

## delete
- 존재하는 디바이스 → 삭제 성공
- 존재하지 않는 → DEVICE_NOT_FOUND
