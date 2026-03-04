# storage-sqlite contracts

## 테이블

### Memos
| 컬럼 | 타입 | 비고 |
|---|---|---|
| id | TEXT PK | UUID |
| content | TEXT | |
| createdAt | DATETIME | default now |
| updatedAt | DATETIME | default now |
| isResolved | BOOL | default false |
| urgentOrder | INT | default 0 |
| dueAt | DATETIME? | nullable |
| alarmEnabled | BOOL | default false |
| alarmNotifiedAt | DATETIME? | nullable |

### DailyPlans
| 컬럼 | 타입 | 비고 |
|---|---|---|
| id | TEXT PK | UUID |
| name | TEXT | |
| date | DATETIME? | 1회성 전용 |
| createdAt | DATETIME | default now |
| updatedAt | DATETIME | default now |

### PlanDays
| 컬럼 | 타입 | 비고 |
|---|---|---|
| planId | TEXT FK→DailyPlans | |
| weekday | TEXT (WeekdayConv) | MON~SUN |
| PK | (planId, weekday) | |

### Routines
| 컬럼 | 타입 | 비고 |
|---|---|---|
| id | TEXT PK | UUID |
| planId | TEXT FK→DailyPlans | |
| name | TEXT | |
| detail | TEXT | default '' |
| startTime | DATETIME | 앵커 or 실제 |
| endTime | DATETIME | |
| tag | TEXT (RoutineTypeConv) | |

### (향후) CalendarEvents, Notes, Archives, SyncOutbox, SyncCursor

## 스키마 버전

| 버전 | 변경 |
|---|---|
| 1 | DailyPlans, PlanDays, Routines |
| 2 | Memos 추가 |
| 3 | Memos.dueAt 추가 |
| 4 | Memos.alarmEnabled, alarmNotifiedAt 추가 |

## 매퍼 규칙

- 도메인 enum ↔ DB enum: index 기반 매핑
- 요일 플랜 시간: 1970-01-01 앵커 날짜로 HH:MM 저장
- 1회성 플랜 시간: 실제 날짜 그대로 저장
