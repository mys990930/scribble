# calendar-domain contracts

## 엔티티

### CalendarEvent

| 필드 | 타입 | 설명 |
|---|---|---|
| id | String (UUID) | 고유 식별자 |
| title | String | 제목 |
| description | String | 설명 (기본 빈 문자열) |
| startTime | DateTime | 시작 시각 |
| endTime | DateTime | 종료 시각 |
| isAllDay | bool | 종일 이벤트 여부 |
| color | int? | 표시 색상 (null이면 기본) |
| sourceId | String? | 원본 Memo ID (전환된 경우) |
| createdAt | DateTime | 생성 시각 |
| updatedAt | DateTime | 수정 시각 |

## 순수 함수

### eventsInRange(List\<CalendarEvent\>, DateTime start, DateTime end) → List\<CalendarEvent\>
- 범위 내 이벤트 필터링 (부분 겹침 포함)

### fromMemo(Memo, DateTime start, DateTime end) → CalendarEvent
- Memo에서 캘린더 이벤트 생성, sourceId에 memo.id 기록

## 에러

| 코드 | 설명 |
|---|---|
| `EVENT_EMPTY_TITLE` | title 빈 문자열 |
| `EVENT_END_BEFORE_START` | endTime ≤ startTime |
| `EVENT_NOT_FOUND` | 조회 대상 없음 |
