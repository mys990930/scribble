# ui-memo contracts

## Provider

| Provider | 타입 | 설명 |
|---|---|---|
| memoServiceProvider | Provider<MemoService> | app_shell/di에서 re-export |
| activeMemosProvider | AsyncNotifierProvider<ActiveMemosNotifier, List<Memo>> | 활성 메모 캐시 유지 + 백그라운드 refresh |
| resolvedMemosProvider | FutureProvider<List<Memo>> | 완료 메모 목록 |

### ActiveMemosNotifier

| 메서드 | 설명 |
|---|---|
| build() | 초기 상태 즉시 반환(캐시 없으면 빈 리스트) + 비동기 refresh 트리거 |
| refresh() | 캐시 유지 상태에서 서버/로컬 재조회 |

## 화면

### MemoScreen
- 입력: 없음
- 출력: 활성 메모 리스트 (ReorderableListView)
- 액션: 추가(dialog), 완료 토글, 알람 아이콘 토글, 드래그 재정렬, 편집 화면 이동, 히스토리 화면 이동, 아래로 당겨 새로고침
- 로딩 UX:
  - 최초 로딩 시 스피너 대신 콘텐츠 영역 유지(빈 상태/기존 캐시 우선)
  - 새로고침 시 기존 리스트 유지 + RefreshIndicator 표시

### MemoEditScreen
- 입력: Memo
- 출력: MemoEditResult (content, dueAt, alarmEnabled, deleteRequested)
- 액션: 저장, 삭제, 기한 변경(시간/일-주 그룹 프리셋 + 커스텀), 알람 토글

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
