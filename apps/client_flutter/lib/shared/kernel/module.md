# shared/kernel

## 목표

전체 프로젝트에서 공유하는 기반 타입, 유틸리티, 인프라 추상화를 제공한다.

## 책임

- ID 생성 (UUID wrapper)
- Result 타입 (Success / Failure)
- 공통 에러 모델 (AppError base class, 에러 코드 체계)
- 시간 유틸리티 (DateTime 확장, 10분 정규화 등)
- 이벤트 버스 (모듈 간 비동기 이벤트 발행/구독)
- 공통 타입 별칭 (EntityId, Timestamp 등)

## 비책임

- 도메인 비즈니스 로직 → 각 domain 모듈
- UI 공통 위젯 → `shared/ui`
- 플랫폼 의존 코드 → adapters

## 의존 모듈

- 없음 (최하위 모듈)

## 의존 방향

```
shared/kernel ← 모든 모듈
shared/kernel → (없음)
```
