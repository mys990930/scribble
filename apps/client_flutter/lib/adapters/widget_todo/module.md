# widget-todo

## 목표

Memo의 네이티브 홈 화면 위젯 (Android/iOS)을 담당한다.

## 책임

- MethodChannel 기반 네이티브 위젯 데이터 동기화 수신
- 위젯에서 메모 추가 시 pendingMemo 전달
- 위젯 탭 시 앱 라우팅 (consumeLaunchRoute)
- v1: 읽기 전용 (메모 목록 표시만)

## 비책임

- 메모 CRUD 로직 → `memo-usecases`
- Flutter 측 MethodChannel 호출 → `ui-memo` (호출 발신)
- 네이티브 위젯 레이아웃 → Android XML / iOS WidgetKit (별도)

## 의존 모듈

- `memo-domain` — Memo 타입 (JSON 직렬화용)
- 네이티브 SDK (MethodChannel)

## 의존 방향

```
widget_todo → memo_domain (타입)
widget_todo ← ui_memo (MethodChannel 호출)
```
