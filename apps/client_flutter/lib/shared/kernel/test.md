# shared/kernel test

## Result
- Success 생성 → value 접근 가능
- Failure 생성 → error 접근 가능
- pattern match (when/switch) 동작 확인

## ID 생성
- newId() → 유효한 UUID v4 형식
- 2회 호출 → 서로 다른 값

## 시간 유틸리티
- is10MinAligned: 14:30:00 → true, 14:33:00 → false
- alignTo10Min: 14:37:22 → 14:30:00
- nowAligned → minute % 10 == 0

## 이벤트 버스
- publish 후 on() 스트림에서 수신 확인
- 구독 전 publish → 수신 안 됨
- 다른 타입 이벤트 → 필터링 확인
- dispose 후 publish → 에러 없음 (무시)

## AppError
- code, message 정상 생성
- cause 포함/미포함 둘 다 가능
