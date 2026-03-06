# settings-usecases

## 목표

설정 상태 조회/수정 유스케이스를 오케스트레이션한다.

## 책임

- 설정 조회/저장 유스케이스
- 기본값 정책 정의
- 설정 저장 인터페이스(`SettingsStore`) 정의

## 비책임

- 설정 화면 UI → `ui-settings`
- 영속화 구현 → `storage-sqlite` 또는 플랫폼 저장소 adapter

## 의존 모듈

- `shared/kernel`

## 의존 방향

```
settings_usecases → shared/kernel
settings_usecases ← ui_settings, app_shell/di
settings_usecases ← storage_sqlite (implements store)
```
