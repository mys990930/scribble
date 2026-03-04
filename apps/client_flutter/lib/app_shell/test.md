# app-shell test

## 앱 시작
- main() → 정상 빌드, 에러 없음
- initialRoute null → HomeScreen
- initialRoute "/memo" → MemoScreen

## _WidgetSyncGate
- resume → consumePendingMemo 호출
- resume → syncWidget 호출
- activeMemosProvider 변경 → syncWidget 호출

## 라우팅
- 각 라우트 → 대응 화면 렌더링

## 경계 케이스
- consumeLaunchRoute 실패 → 기본 라우트
- MethodChannel 미지원 플랫폼 → 무시
