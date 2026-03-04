# memo-domain contracts

## 엔티티

### Memo

| 필드 | 타입 | 설명 |
|---|---|---|
| id | String (UUID) | 고유 식별자 |
| content | String | 메모 본문 (빈 문자열 불허) |
| createdAt | DateTime | 생성 시각 |
| updatedAt | DateTime | 최종 수정 시각 |
| isResolved | bool | 완료 여부 (기본 false) |
| urgentOrder | int | 우선순위 정렬값 (높을수록 상위) |
| dueAt | DateTime? | 기한 (null = 기한 없음) |
| alarmEnabled | bool | 알람 활성화 여부 |
| alarmNotifiedAt | DateTime? | 알람 발송 시각 (null = 미발송) |

### copyWith 규칙

- `clearDueAt: true` → dueAt를 null로 초기화
- `clearAlarmNotifiedAt: true` → alarmNotifiedAt를 null로 초기화
- 나머지 필드는 null 전달 시 기존 값 유지

## 순수 함수

### isOverdue(Memo, DateTime now) → bool

- `dueAt != null && dueAt.isBefore(now)`

### remainingDuration(Memo, DateTime now) → Duration?

- dueAt가 null이면 null 반환
- `dueAt.difference(now)` (음수 가능)

### shouldNotifyAlarm(Memo, DateTime now) → bool

조건 (모두 충족 시 true):
1. `alarmEnabled == true`
2. `dueAt != null`
3. `alarmNotifiedAt == null`
4. 전체 기간(`dueAt - createdAt`) > 0
5. 잔여 비율(`remaining / total`) ≤ 0.1 (10% 이하)

## 에러

| 코드 | 설명 |
|---|---|
| `MEMO_EMPTY_CONTENT` | content가 빈 문자열 또는 공백만 |
| `MEMO_NOT_FOUND` | 조회/수정 대상 Memo 없음 |

## 이벤트 (예정)

현재 v1에서는 이벤트 발행 없음. 향후 sync 연동 시 아래 이벤트 추가 예정:
- `MemoCreated`
- `MemoUpdated`
- `MemoResolved`
- `MemoDeleted`
