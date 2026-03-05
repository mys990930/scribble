# app-shell test

## 앱 시작
- main() → 정상 빌드, 에러 없음
- initialRoute null → HomeScreen
- initialRoute "/memo" → MemoScreen
- pending share 존재 시 category 선택 플로우 진입
- 카테고리 확정 전 자동 저장되지 않음

## _WidgetSyncGate
- resume → consumePendingMemo 호출
- resume → syncWidget 호출
- activeMemosProvider 변경 → syncWidget 호출

## 공유 브릿지 연결
- consumePendingShare 반환 null → 공유 플로우 미진입
- consumePendingShare 반환 payload → ui-archive 공유 플로우 전달

## 라우팅
- 각 라우트 → 대응 화면 렌더링

## 경계 케이스
- consumeLaunchRoute 실패 → 기본 라우트
- MethodChannel 미지원 플랫폼 → 무시
