# dailyplan-domain test

## DailyPlan 엔티티
- 1회성 플랜 생성 (date 지정) → isOneOff == true
- 반복 플랜 생성 (days 지정) → isRecurring == true
- date, days 둘 다 null → `PLAN_NO_SCHEDULE`
- name 빈 문자열 → `PLAN_EMPTY_NAME`

## Routine 엔티티
- 정상 시간(10분 정렬) 생성 → 성공
- startTime 분이 7 → `ROUTINE_TIME_NOT_ALIGNED`
- endTime ≤ startTime → `ROUTINE_END_BEFORE_START`

## is10MinAligned
- 14:30:00.000 → true
- 14:33:00.000 → false
- 14:30:01.000 → false

## planForDate
- 1회성 플랜 날짜 일치 → 해당 플랜 반환
- 1회성 + 요일 둘 다 매칭 → 1회성 우선
- 요일만 매칭 → 해당 플랜 반환
- 아무것도 매칭 안 됨 → null

## routineProgress
- now가 start 이전 → 0.0
- now가 end 이후 → 1.0
- start~end 정중앙 → 0.5
- start == now → 0.0
- end == now → 1.0

## planProgress
- 루틴 3개, 진행률 0.0/0.5/1.0 → 평균 0.5
- 루틴 0개 → 0.0 (빈 플랜)

## Quick Tag
- groupOf(WORK) → WORK
- groupOf(EAT) → PLAY
- groupOf(SLEEP) → SLEEP

## 경계 케이스
- Routine 겹침 → 허용 (에러 아님)
- 같은 요일에 여러 플랜 → planForDate는 첫 번째 반환
