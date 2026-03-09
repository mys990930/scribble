# sync_api

## 목표

클라이언트의 변경 이벤트를 멀티디바이스에 반영하는 동기화 엔드포인트를 제공한다.

## 책임

- push 요청 수신
- pull 요청 응답
- cursor 기반 증분 동기화
- LWW 충돌 해결
- tombstone 전파
- cursor 만료 판정
- sync 이벤트 저장과 재조회

## 비책임

- 사용자 로그인과 세션 발급
- 디바이스 등록과 해제
- 도메인별 비즈니스 규칙 해석
- 서버사이드 도메인 CRUD

## 의존 모듈

- `core`
- `auth_session`
- `device_registry`

## 의존 방향

```text
sync_api -> core
sync_api -> auth_session
sync_api -> device_registry
```
