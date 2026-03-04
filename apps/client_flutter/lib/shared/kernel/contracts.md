# shared/kernel contracts

## 타입

### EntityId
- `typedef EntityId = String` (UUID v4)

### Result\<T\>
```
sealed class Result<T>
  ├─ Success<T>(T value)
  └─ Failure<T>(AppError error)
```

### AppError
| 필드 | 타입 | 설명 |
|---|---|---|
| code | String | 에러 코드 (모듈 prefix + 이름) |
| message | String | 사람 읽기용 메시지 |
| cause | Object? | 원인 예외 |

에러 코드 컨벤션: `{MODULE}_{ERROR_NAME}` (예: `MEMO_EMPTY_CONTENT`)

## 유틸리티

### ID 생성
- `newId() → EntityId` — UUID v4 생성

### 시간
- `is10MinAligned(DateTime) → bool`
- `alignTo10Min(DateTime) → DateTime` — 내림 정규화
- `nowAligned() → DateTime` — 현재 시각 10분 내림

### 이벤트 버스
- `EventBus.publish<T>(T event) → void`
- `EventBus.on<T>() → Stream<T>`
- 앱 생명주기에 따라 dispose 필요

## 에러 코드 (공통)

| 코드 | 설명 |
|---|---|
| `KERNEL_INVALID_ID` | 유효하지 않은 ID 형식 |
| `KERNEL_UNEXPECTED` | 예상치 못한 오류 |
