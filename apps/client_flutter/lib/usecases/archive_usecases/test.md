# archive-usecases test

## HandleShare
- URL 포함 텍스트 + fetch 성공 → captureType=full
- URL 포함 + fetch 실패 → captureType=fallback
- URL 없는 텍스트 → captureType=fallback
- 빈 텍스트 → 에러

## ListArchives
- category 지정 → 해당 카테고리만
- category null → 전체

## SearchArchives
- query 포함 제목/본문/카테고리 검색
- category + query 동시 적용

## ListRecentCategories
- 최근 저장 순으로 unique 카테고리 반환

## UpdateArchive
- title/body/category 수정 저장
- 없는 id 수정 시 `ARCHIVE_NOT_FOUND`

## SendToNote
- 정상 archive → note_usecases ingest 호출 확인
- 존재하지 않는 archiveId → `ARCHIVE_NOT_FOUND`

## 경계 케이스
- 여러 URL 포함 텍스트 → 첫 번째 URL 사용
- 이미지 없는 페이지(fetch 성공) → imageUrl=null, 여전히 full
