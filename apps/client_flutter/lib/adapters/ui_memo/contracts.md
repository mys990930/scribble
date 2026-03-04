# ui-memo contracts

## Provider

| Provider | 타입 | 설명 |
|---|---|---|
| memoRepoProvider | Provider\<MemoRepository\> | MemoRepo DI |
| activeMemosProvider | FutureProvider\<List\<Memo\>\> | 미완료 메모 목록 |
| resolvedMemosProvider | FutureProvider\<List\<Memo\>\> | 완료 메모 목록 |

## 화면

### MemoScreen
- 입력: 없음
- 출력: 활성 메모 리스트 (ReorderableListView)
- 액션: 추가(dialog), 완료 토글, 드래그 재정렬, 편집 화면 이동, 히스토리 화면 이동

### MemoEditScreen
- 입력: Memo
- 출력: MemoEditResult (content, dueAt, alarmEnabled, deleteRequested)
- 액션: 저장, 삭제, 기한 변경, 알람 토글

### MemoHistoryScreen
- 입력: 없음
- 출력: 완료 메모 리스트
- 액션: 복원 (unresolve)

## MemoEditResult

| 필드 | 타입 | 설명 |
|---|---|---|
| content | String | 수정된 내용 |
| dueAt | DateTime? | 수정된 기한 |
| alarmEnabled | bool | 알람 여부 |
| deleteRequested | bool | 삭제 요청 (기본 false) |

## MethodChannel

- 채널명: `scribble/widget`
- `updateMemos({memosJson})`: 활성 메모 JSON을 네이티브 위젯에 전달
- `consumePendingMemo()`: 위젯에서 추가된 메모 수신
- `consumeLaunchRoute()`: 위젯 탭으로 앱 진입 시 라우트
