# core

## 목표

백엔드의 모든 모듈이 공유하는 인프라를 제공한다.

## 책임

- 환경 설정 로딩
- DB 엔진, 세션 팩토리, Base 모델 제공
- 공통 에러 모델과 예외 변환
- 인증 dependency helper 제공
- request-id, CORS 등 공통 미들웨어 제공
- cursor / pagination 유틸 제공

## 비책임

- 로그인, 세션 발급, 로그아웃 로직
- 디바이스 등록/검증 정책
- 동기화 비즈니스 규칙
- 도메인 데이터 규칙

## 의존 모듈

- 없음

## 의존 방향

```text
core <- auth_session
core <- device_registry
core <- sync_api
```
