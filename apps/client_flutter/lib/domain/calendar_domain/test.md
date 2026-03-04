# calendar-domain test

## CalendarEvent
- 정상 생성 → 성공
- title 빈 문자열 → `EVENT_EMPTY_TITLE`
- endTime ≤ startTime → `EVENT_END_BEFORE_START`
- isAllDay=true → start/end는 날짜 단위

## eventsInRange
- 범위 완전 포함 → 반환
- 부분 겹침 (시작만 범위 안) → 반환
- 범위 밖 → 미반환
- 빈 리스트 → 빈 결과

## fromMemo
- Memo content → event title
- sourceId == memo.id
- start/end 지정 필수

## 경계 케이스
- 종일 이벤트 범위 필터 → 해당 날짜 전체 포함
- color null → 기본 색상 사용 (UI 책임)
