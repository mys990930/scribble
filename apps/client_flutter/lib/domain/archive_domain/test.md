# archive-domain test

## ArchiveEntry
- URL + 이미지 정상 → captureType=full
- URL만, 이미지 없음 → captureType=fallback
- 직접 입력 → captureType=manual
- title, body 둘 다 빈 문자열 → `ARCHIVE_EMPTY_CONTENT`
- category 빈 문자열 → `ARCHIVE_INVALID_CATEGORY`

## 경계 케이스
- url null + body 있음 → 허용 (manual)
- imageUrl null → 허용
- category 커스텀 문자열 → 허용
