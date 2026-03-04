# dailyplan-usecases contracts

## Repository 인터페이스

### DailyPlanRepository (abstract)

| 메서드 | 설명 |
|---|---|
| loadAll() → Future\<List\<DailyPlan\>\> | 전체 플랜 조회 |
| getById(String id) → Future\<DailyPlan?\> | 단건 조회 |
| save(DailyPlan) → Future\<void\> | 생성/수정 |
| delete(String id) → Future\<void\> | 삭제 |
| addRoutine(Routine) → Future\<void\> | 루틴 추가 |
| updateRoutine(Routine) → Future\<void\> | 루틴 수정 |
| deleteRoutine(String id) → Future\<void\> | 루틴 삭제 |

## Usecase

| 이름 | 입력 | 출력 | 설명 |
|---|---|---|---|
| GetTodayPlan | DateTime | DailyPlan? | planForDate 위임 |
| CreatePlan | name, date/days | DailyPlan | 생성 후 저장 |
| UpdatePlan | DailyPlan | void | 수정 후 저장 |
| DeletePlan | planId | void | 삭제 |
| AddRoutine | planId, Routine 필드 | Routine | 유효성 검증 후 추가 |
| EditRoutine | Routine | void | 유효성 검증 후 수정 |
| RemoveRoutine | routineId | void | 삭제 |
