# ui-archive

## 목표

Archive 기능의 Flutter 화면을 담당한다.

## 책임

- ArchiveScreen: 아카이브 목록 (카테고리별 필터)
- 아카이브 상세 화면
- 카테고리 선택 UI

## 비책임

- Archive 규칙 → `archive-domain`
- 수집/전환 흐름 → `archive-usecases`
- 테마 → `shared/ui`

## 의존 모듈

- `archive-usecases`
- `archive-domain`
- `shared/ui`

## 의존 방향

```
ui_archive → archive_usecases, archive_domain, shared/ui
ui_archive ← app_shell
```
