# storage-sqlite test

## MemoDao
- listActive → isResolved=false, urgentOrder DESC 정렬
- listResolved → isResolved=true, updatedAt DESC 정렬
- upsertMemo → 신규 삽입 + 기존 업데이트
- deleteMemo → 삭제 후 조회 시 없음
- getMaxUrgentOrder / getMinUrgentOrder → 정확한 값

## DriftMemoRepo
- addMemo (빈 목록) → urgentOrder=0
- addMemo (dueAt 기반 삽입) → 올바른 위치
- addMemo (간격 부족) → shift 동작
- reorderActiveMemos → urgentOrder 재할당
- toggleResolved → isResolved 토글 + alarmNotifiedAt 처리

## 매퍼
- toDomainWeekday ↔ toDbWeekday 왕복
- toDomainTag ↔ toDbTag 왕복
- toAnchored → 1970-01-01 + HH:MM
- combineDateAndTime → 실제 날짜 + 앵커 시간

## 마이그레이션
- v1→v4 순차 마이그레이션 → 에러 없음
- v4 신규 생성 → 전체 테이블 존재

## 경계 케이스
- DB 파일 없음 (최초 실행) → 자동 생성
- 동시 트랜잭션 → drift 기본 직렬화
