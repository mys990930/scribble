# memo-domain test

## Memo 엔티티

### 생성
- 모든 필수 필드로 Memo 생성 → 정상 인스턴스
- content 빈 문자열 → `MEMO_EMPTY_CONTENT` (유효성 검증 도입 시)

### copyWith
- 단일 필드 변경 → 해당 필드만 변경, 나머지 유지
- `clearDueAt: true` → dueAt가 null
- `clearDueAt: false` + `dueAt: null` → 기존 dueAt 유지
- `clearAlarmNotifiedAt: true` → alarmNotifiedAt가 null

## 순수 함수

### isOverdue
- dueAt가 now 이전 → true
- dueAt가 now 이후 → false
- dueAt가 null → false

### remainingDuration
- dueAt가 null → null
- dueAt가 now보다 30분 뒤 → Duration(minutes: 30)
- dueAt가 now보다 10분 전 → Duration(minutes: -10)

### shouldNotifyAlarm
- alarmEnabled=false → false
- dueAt=null → false
- alarmNotifiedAt≠null (이미 발송) → false
- total=60분, remaining=6분 (10%) → true
- total=60분, remaining=7분 (11.7%) → false
- total=0분 (createdAt==dueAt) → false

## 경계 케이스
- urgentOrder 음수 → 허용 (정렬값이므로 음수 가능)
- dueAt == createdAt → shouldNotifyAlarm은 false (total=0 방어)
- content 길이 제한 → v1에서는 제한 없음
