# archive-usecases test

## HandleShare
- URL 포함 텍스트 + fetch 성공 → captureType=full
- URL 포함 + fetch 실패 → captureType=fallback
- URL 없는 텍스트 → captureType=fallback
- 빈 텍스트 → 에러

## ListArchives
- category 지정 → 해당 카테고리만
- category null → 전체

## SendToNote
- 정상 archive → Note 생성 확인 (note_usecases 호출)
- 존재하지 않는 archiveId → `ARCHIVE_NOT_FOUND`

## 경계 케이스
- 여러 URL 포함 텍스트 → 첫 번째 URL 사용
- 이미지 없는 페이지 → imageUrl=null, 여전히 full
