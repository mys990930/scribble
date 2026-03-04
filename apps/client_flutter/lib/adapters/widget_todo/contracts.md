# widget-todo contracts

## MethodChannel: `scribble/widget`

### Flutter → Native

| 메서드 | 파라미터 | 설명 |
|---|---|---|
| updateMemos | {memosJson: String} | 활성 메모 JSON 배열 전달 (최대 25개) |

#### memosJson 항목

| 필드 | 타입 | 설명 |
|---|---|---|
| id | String | 메모 ID |
| content | String | 본문 |
| urgentOrder | int | 정렬 순서 |
| dueAtEpochMs | int? | 기한 (epoch ms, null 허용) |

### Native → Flutter

| 메서드 | 반환 | 설명 |
|---|---|---|
| consumePendingMemo | String? | 위젯에서 입력된 메모 JSON (null이면 없음) |
| consumeLaunchRoute | String? | 위젯 탭 시 라우트 (예: `/memo`) |

#### consumePendingMemo JSON

| 필드 | 타입 | 설명 |
|---|---|---|
| text | String | 메모 내용 |
| dueMinutes | int? | 기한 (분 단위, null 허용) |
