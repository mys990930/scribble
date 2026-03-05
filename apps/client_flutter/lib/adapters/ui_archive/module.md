# ui-archive

## 목표

Archive 기능의 Flutter 화면을 담당한다.

## 책임

- ArchiveScreen: 아카이브 목록 (카테고리별 필터 + 검색)
- 아카이브 상세/편집 화면
- 외부 공유 진입 시 카테고리 선택 화면(저장 전)
- 최근 사용 카테고리 우선 선택 UX
- 저장 성공/실패 피드백(스낵바/에러 표시)

## 비책임

- Archive 규칙 → `archive-domain`
- 수집/전환 흐름 → `archive-usecases`
- 공유 payload 수신 브릿지 → `share-intent`
- 테마 → `shared/ui`

## 의존 모듈

- `archive-usecases`
- `archive-domain`
- `share-intent`
- `shared/ui`

## 의존 방향

```
ui_archive → archive_usecases, archive_domain, share_intent, shared/ui
ui_archive ← app_shell
```
