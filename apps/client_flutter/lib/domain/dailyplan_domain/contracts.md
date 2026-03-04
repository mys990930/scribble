# dailyplan-domain contracts

## 엔티티

### DailyPlan

| 필드 | 타입 | 설명 |
|---|---|---|
| id | String (UUID) | 고유 식별자 |
| name | String | 플랜 이름 |
| date | DateTime? | 1회성 플랜 날짜 (null이면 반복) |
| days | List\<Weekday\>? | 반복 요일 목록 (null이면 1회성) |
| routines | List\<Routine\> | 소속 루틴 목록 |
| createdAt | DateTime | 생성 시각 |
| updatedAt | DateTime | 수정 시각 |

- `isOneOff` → `date != null`
- `isRecurring` → `days != null && days.isNotEmpty`

### Routine

| 필드 | 타입 | 설명 |
|---|---|---|
| id | String (UUID) | 고유 식별자 |
| planId | String | 소속 DailyPlan ID |
| name | String | 루틴 이름 |
| detail | String | 상세 설명 (기본 빈 문자열) |
| startTime | DateTime | 시작 시각 (10분 단위) |
| endTime | DateTime | 종료 시각 (10분 단위) |
| tag | RoutineType | Quick Tag |

### Weekday

`MON | TUE | WED | THU | FRI | SAT | SUN`

### RoutineType

`SLEEP | EAT | WORK | PLAY | SELFDEV`

### QuickTagGroup

`WORK | PLAY | SLEEP` — RoutineType → QuickTagGroup 매핑 함수 `groupOf()`

## 순수 함수

### is10MinAligned(DateTime) → bool
- minute % 10 == 0 && second == 0 && millisecond == 0

### validateRoutineTimes(start, end)
- 둘 다 10분 정렬 필수, end > start 필수 → 위반 시 ArgumentError

### planForDate(List\<DailyPlan\>, DateTime date) → DailyPlan?
- 1회성(date 일치) 우선 → 요일 매칭 폴백 → 없으면 null

### routineProgress(Routine, DateTime now) → double (0.0~1.0)
- now < start → 0.0 / now > end → 1.0 / 사이 → 비례 계산

### planProgress(DailyPlan, DateTime now) → double
- 전체 루틴 routineProgress 평균

## 에러

| 코드 | 설명 |
|---|---|
| `PLAN_EMPTY_NAME` | name이 빈 문자열 |
| `PLAN_NO_SCHEDULE` | date도 days도 없음 |
| `ROUTINE_TIME_NOT_ALIGNED` | 시각이 10분 단위 아님 |
| `ROUTINE_END_BEFORE_START` | endTime ≤ startTime |

## 이벤트 (예정)

v1에서는 이벤트 발행 없음.
