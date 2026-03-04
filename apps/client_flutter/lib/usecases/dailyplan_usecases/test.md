# dailyplan-usecases test

## GetTodayPlan
- 오늘 1회성 플랜 존재 → 반환
- 오늘 요일 매칭 → 반환
- 매칭 없음 → null

## CreatePlan
- 정상 입력 → 저장 호출 확인
- name 빈 문자열 → 도메인 에러 전파

## AddRoutine
- 정상 시간 → 저장 호출
- 10분 미정렬 → 도메인 에러 전파
- end ≤ start → 도메인 에러 전파

## DeletePlan
- 존재하는 planId → 삭제 성공
- 존재하지 않는 planId → 에러 또는 무시

## 경계 케이스
- 같은 요일에 플랜 2개 → GetTodayPlan은 첫 번째 반환 (도메인 규칙)
