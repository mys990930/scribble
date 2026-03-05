# archive-usecases contracts

## Repository 인터페이스

### ArchiveRepository (abstract)

| 메서드 | 설명 |
|---|---|
| listAll() → Future\<List\<ArchiveEntry\>\> | 전체 조회 |
| listByCategory(String) → Future\<List\<ArchiveEntry\>\> | 카테고리별 |
| search(String, {category?}) → Future\<List\<ArchiveEntry\>\> | 제목/본문/카테고리 검색 |
| listRecentCategories() → Future\<List\<String\>\> | 최근 사용 순 카테고리 목록 |
| getById(String id) → Future\<ArchiveEntry?\> | 단건 조회 |
| save(ArchiveEntry) → Future\<void\> | 저장 |
| delete(String id) → Future\<void\> | 삭제 |

### UrlFetcher (abstract)

| 메서드 | 설명 |
|---|---|
| fetch(String url) → Future\<FetchResult\> | URL에서 title/body/imageUrl 추출 |

### FetchResult

| 필드 | 타입 | 설명 |
|---|---|---|
| title | String? | 페이지 제목 |
| body | String? | 본문 텍스트 |
| imageUrl | String? | 대표 이미지 |
| success | bool | 수집 성공 여부 |

### SharedContent

| 필드 | 타입 | 설명 |
|---|---|---|
| rawText | String | 공유된 원문 텍스트 |
| category | String | 저장 카테고리 |

## Usecase

| 이름 | 입력 | 출력 | 설명 |
|---|---|---|---|
| HandleShare | SharedContent | ArchiveEntry | URL 파싱 → fetch → 폴백 → 저장 |
| ListArchives | category? | List\<ArchiveEntry\> | 전체 또는 카테고리별 |
| SearchArchives | query, category? | List\<ArchiveEntry\> | 부분 일치 검색 |
| ListRecentCategories | - | List\<String\> | 최근 사용 카테고리 조회 |
| UpdateArchive | archiveId, title, body, category | ArchiveEntry | 상세 수정 저장 |
| DeleteArchive | archiveId | void | 삭제 |
| SendToNote | archiveId | void | Archive→Note 전환 |

## 에러

| 코드 | 설명 |
|---|---|
| `ARCHIVE_NOT_FOUND` | 조회 대상 없음 |

## 수집 흐름

1. SharedContent에서 URL 추출 시도
2. URL 있으면 → UrlFetcher.fetch() 호출
3. 성공 → captureType=full로 저장 (imageUrl은 null 가능)
4. 실패 또는 URL 없음 → 원본 텍스트로 captureType=fallback 저장
