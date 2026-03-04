# calendar-usecases test

## GetEventsForDay
- 해당 일에 이벤트 2개 → 2개 반환
- 해당 일 이벤트 없음 → 빈 리스트

## ConvertMemoToEvent
- 정상 Memo + 시간 → CalendarEvent 생성, sourceId 확인
- end ≤ start → 도메인 에러 전파

## CreateEvent
- 정상 → 저장 호출
- title 빈 문자열 → 에러

## 경계 케이스
- 종일 이벤트 → GetEventsForDay에 포함
- 자정 걸치는 이벤트 → 양쪽 날짜 모두 포함
