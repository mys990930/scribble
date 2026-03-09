# auth_session

## 목표

사용자 인증과 세션 수명주기를 담당한다.

## 책임

- 계정 생성
- 로그인
- access / refresh token 발급
- refresh token 검증과 회전
- 로그아웃과 세션 무효화
- 현재 사용자 조회

## 비책임

- 디바이스 등록과 해제
- sync 요청의 device 검증
- sync event 저장

## 의존 모듈

- `core`

## 의존 방향

```text
auth_session -> core
auth_session <- device_registry
auth_session <- sync_api
```
