# calendar-usecases contracts

## Repository 인터페이스

### CalendarEventRepository (abstract)

| 메서드 | 설명 |
|---|---|
| getEventsInRange(start, end) → Future\<List\<CalendarEvent\>\> | 범위 조회 |
| getById(String id) → Future\<CalendarEvent?\> | 단건 조회 |
| save(CalendarEvent) → Future\<void\> | 생성/수정 |
| delete(String id) → Future\<void\> | 삭제 |

## Usecase

| 이름 | 입력 | 출력 | 설명 |
|---|---|---|---|
| GetEventsForDay | DateTime | List\<CalendarEvent\> | 해당 일 이벤트 |
| GetEventsForWeek | DateTime (주 시작) | List\<CalendarEvent\> | 해당 주 이벤트 |
| GetEventsForMonth | year, month | List\<CalendarEvent\> | 해당 월 이벤트 |
| CreateEvent | 필드 | CalendarEvent | 유효성 검증 후 저장 |
| ConvertMemoToEvent | Memo, start, end | CalendarEvent | fromMemo 위임 |
| DeleteEvent | eventId | void | 삭제 |
