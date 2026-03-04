# archive-domain

## 목표

Archive(외부 수집 콘텐츠)의 순수 비즈니스 규칙을 정의한다.

## 책임

- ArchiveEntry 엔티티: id, url, title, body, imageUrl, category, 생성 시각
- Category 규칙: 사전 정의 카테고리 + 커스텀 허용
- 수집 결과 타입 정의: full(URL+이미지) vs fallback(링크+텍스트)

## 비책임

- 실제 URL fetch / 이미지 다운로드 → `archive-usecases`
- Share Intent 수신 → `archive-usecases`
- Archive→Note 흐름 → `archive-usecases`
- 영속화 → `storage-sqlite`
- UI → `ui-archive`

## 의존 모듈

- `shared/kernel`

## 의존 방향

```
archive_domain → shared/kernel (only)
archive_domain ← archive_usecases, ui_archive, storage_sqlite
```
