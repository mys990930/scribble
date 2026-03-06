# ui-memo test

## MemoScreen
- 빈 목록 → "No memos yet" 메시지 표시
- 메모 3개 → 3개 카드 렌더링
- 완료 토글 → active/resolved provider refresh/invalidate 확인
- 알람 아이콘 탭 → alarmEnabled 토글 + active 리스트 refresh
- 드래그 재정렬 → reorderActiveMemos 호출 확인

## 초기 로딩/캐시 UX
- 앱 최초 진입(캐시 없음) → 중앙 스피너 없이 기본 콘텐츠 영역 유지
- 캐시 존재 상태 재진입 → 캐시 리스트 즉시 렌더
- 백그라운드 refresh 실패 → 기존 캐시 유지 + 에러 비차단 처리

## Pull-to-Refresh
- 리스트를 아래로 당김 → activeMemosProvider.notifier.refresh() 호출
- refresh 중에도 기존 리스트 유지
- refresh 완료 후 최신 순서/상태 반영

## MemoEditScreen
- 기존 content 표시 확인
- 기한 프리셋 1h/2h/3h/6h/12h 선택 → dueAt 반영
- 기한 프리셋 1d/3d/1w 선택 → dueAt 반영
- No due 선택 후 Save → dueAt null 반영
- 커스텀 시간 입력 → dueAt 반영
- 삭제 버튼 → deleteRequested=true 반환
- Save → MemoEditResult 반환

## MemoHistoryScreen
- 완료 메모 2개 → 2개 표시, lineThrough 스타일
- Unresolve → toggleResolved(false) 호출

## 알람
- checkAlarms 결과 존재 → 로컬 알림 발송, alarmNotifiedAt 갱신
- checkAlarms 결과 없음 → 알림 안 보냄

## 경계 케이스
- 빈 content로 Add → 추가 안 됨
