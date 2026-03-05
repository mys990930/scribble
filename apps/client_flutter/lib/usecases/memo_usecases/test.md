# memo-usecases test

## AddMemo
- 빈 목록에 추가 → urgentOrder=0
- dueAt 있는 메모 → 기존 목록에서 올바른 위치에 삽입
- dueAt 없는 메모 → 최하위 삽입
- content 빈 문자열/공백 → `MEMO_EMPTY_CONTENT`

## UpdateMemo
- content trim 반영
- content 빈 문자열/공백 → `MEMO_EMPTY_CONTENT`

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

## 경계 케이스
- urgentOrder 간격 부족 시 shift 동작 확인
