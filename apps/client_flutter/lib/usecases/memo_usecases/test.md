# memo-usecases test

## AddMemo
- 빈 목록에 추가 → urgentOrder=0
- dueAt 있는 메모 → 기존 목록에서 올바른 위치에 삽입
- dueAt 없는 메모 → 최하위 삽입
- content 빈 문자열 → 도메인 에러 전파

## ToggleResolved
- 미완료 → 완료: isResolved=true
- 완료 → 복원: isResolved=false, alarmNotifiedAt 초기화

## ReorderMemos
- 3개 메모 순서 변경 → urgentOrder 재할당 확인
- 단일 메모 → urgentOrder 변경 없음

## CheckAlarms
- shouldNotifyAlarm=true인 메모 2개 → 2개 반환
- 모두 false → 빈 리스트
- 이미 notified → 제외

## ConvertToNote
- 정상 Memo → Note 생성 (sourceType=memo, sourceId=memo.id)
- 존재하지 않는 memoId → `MEMO_NOT_FOUND`

## ConvertToCalendarEvent
- 정상 → CalendarEvent 생성 (sourceId=memo.id)
- end ≤ start → 에러

## 경계 케이스
- urgentOrder 간격 부족 시 shift 동작 확인
- 동시 AddMemo → 트랜잭션 안전성 (storage 책임이지만 usecase가 트랜잭션 경계 제공)
