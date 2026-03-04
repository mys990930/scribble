# archive-usecases

## 목표

Archive의 Share 수신, URL 수집, 폴백, Archive→Note 흐름을 조율한다.

## 책임

- Share Intent 수신 처리 (텍스트/URL 파싱)
- URL+이미지 수집 시도 (fetcher)
- 수집 실패 시 폴백 (링크+텍스트 저장)
- 카테고리 선택 흐름
- Archive→Note 전환 흐름 (note-usecases의 IngestFromArchive 호출)
- 저장소 인터페이스 정의 (ArchiveRepository abstract class)
- Fetcher 인터페이스 정의 (UrlFetcher abstract class)

## 비책임

- 비즈니스 규칙 → `archive-domain`
- Note 저장 → `note-usecases`
- DB 구현 → `storage-sqlite`
- 실제 HTTP fetch → adapter (implements UrlFetcher)
- UI → `ui-archive`

## 의존 모듈

- `archive-domain`
- `shared/kernel`

## 의존 방향

```
archive_usecases → archive_domain, shared/kernel
archive_usecases ← ui_archive, storage_sqlite(implements repo)
archive_usecases → note_usecases (Archive→Note 전환 시, 인터페이스 주입)
```
