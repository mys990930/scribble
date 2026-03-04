# ui-memo test

## MemoScreen
- 빈 목록 → "No memos yet" 메시지 표시
- 메모 3개 → 3개 카드 렌더링
- 완료 토글 → activeMemosProvider invalidate 확인
- 드래그 재정렬 → reorderActiveMemos 호출 확인

## MemoEditScreen
- 기존 content 표시 확인
- 기한 프리셋 1h 선택 → dueAt ≈ now+1h
- 프리셋 재선택(토글 해제) → dueAt null
- 커스텀 시간 입력 → dueAt 반영
- 삭제 버튼 → deleteRequested=true 반환
- Save → MemoEditResult 반환

## MemoHistoryScreen
- 완료 메모 2개 → 2개 표시, lineThrough 스타일
- Unresolve → toggleResolved(false) 호출

## 알람
- 알람 대상 메모 존재 → 로컬 알림 발송, alarmNotifiedAt 갱신
- 이미 notified → 알림 안 보냄
- alarmEnabled=false → 알림 안 보냄

## 위젯 동기화
- 메모 추가 후 → updateMemos 호출 확인
- consumePendingMemo에 데이터 있음 → 메모 추가
- consumePendingMemo에 데이터 없음 → 아무 일 없음

## 경계 케이스
- 빈 content로 Add → 추가 안 됨
- MethodChannel 실패 → 무시 (try-catch)
