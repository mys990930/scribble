# device_registry

## 목표

인증된 사용자별 디바이스 등록과 검증을 담당한다.

## 책임

- 디바이스 등록
- 디바이스 목록 조회
- 디바이스 해제
- 디바이스 수 제한 정책 적용
- sync 요청의 device 유효성 검증
- last_sync_at 갱신

## 비책임

- 로그인과 토큰 발급
- sync push/pull 처리
- 도메인 데이터 해석

## 의존 모듈

- `core`
- `auth_session`

## 의존 방향

```text
device_registry -> core
device_registry -> auth_session
device_registry <- sync_api
```
