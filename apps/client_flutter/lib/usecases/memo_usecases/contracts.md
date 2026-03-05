# memo-usecases contracts

## Repository 인터페이스

### MemoRepository (abstract)

| 메서드 | 설명 |
|---|---|
| listActive() → Future<List<Memo>> | 미완료 메모 (urgentOrder DESC) |
| listResolved() → Future<List<Memo>> | 완료 메모 (updatedAt DESC) |
| getById(String id) → Future<Memo?> | 단건 조회 |
| upsert(Memo) → Future<void> | 생성/수정 |
| delete(String id) → Future<void> | 삭제 |
| getMaxUrgentOrder() → Future<int?> | 최대 urgentOrder |
| getMinUrgentOrder() → Future<int?> | 최소 urgentOrder |

## Service 인터페이스

### MemoService

| 메서드 | 입력 | 출력 | 설명 |
|---|---|---|---|
| listActiveMemos | — | List<Memo> | 미완료 목록 |
| listResolvedMemos | — | List<Memo> | 완료 목록 |
| addMemo | content, dueAt?, alarmEnabled | void | dueAt 기반 자동 삽입 위치 계산 |
| updateMemo | Memo | void | 수정 |
| toggleResolved | memoId, bool | void | 완료/복원 토글 |
| deleteMemo | memoId | void | 삭제 |
| reorderActiveMemos | List<String> idsInOrder | void | UI 순서대로 urgentOrder 재할당 |
| checkAlarms | DateTime now | List<Memo> | 알람 대상 메모 반환 (`shouldNotifyAlarm`) |

## 정렬 알고리즘

AddMemo 시 urgentOrder 할당:
1. 기존 활성 목록에서 dueAt 기준 삽입 위치 탐색
2. 인접 urgentOrder 사이 중간값 할당
3. 간격 부족 시 하위 항목 shift (-1)
