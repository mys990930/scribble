# widget-todo test

## updateMemos
- 메모 3개 JSON → 네이티브 수신 확인
- 빈 배열 → 위젯 빈 상태
- 25개 초과 → 25개만 전달

## consumePendingMemo
- 데이터 있음 → JSON 파싱 후 메모 추가
- null → 아무 일 없음
- 잘못된 JSON → 무시 (에러 없음)

## consumeLaunchRoute
- "/memo" → MemoScreen으로 이동
- null → 기본 라우트

## 경계 케이스
- MethodChannel 미연결 (웹/데스크톱) → 에러 없이 무시
