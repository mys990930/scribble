# auth-session

## 목표

사용자 인증 및 세션 관리를 담당한다.

## 책임

- 로그인/로그아웃
- 세션 토큰 발급/갱신/검증
- 사용자 계정 관리 (생성/조회)

## 비책임

- 디바이스 관리 → `device-registry`
- 동기화 → `sync-api`
- 클라이언트 측 토큰 저장 → `api-client`

## 의존 모듈

- 없음 (백엔드 독립 모듈)

## 의존 방향

```
auth_session ← sync_api, device_registry (인증 검증)
```
