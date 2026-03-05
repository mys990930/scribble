# note-usecases test

## CreateNote
- 정상 → 저장, 태그 정규화 확인
- title 빈 문자열 → 에러

## IngestFromMemo
- content="첫 줄\n본문" → title="첫 줄", body 전체
- content 50자 초과 한 줄 → title truncate+"…"
- tags에 "from-memo" 포함 확인
- sourceType/sourceId 확인

## IngestFromArchive
- url 있는 archive → body 끝에 원본 링크
- url 없는 archive → 본문만
- tags에 category + "from-archive" 포함
- 반환값 없이(note 타입 의존 없이) ingest 호출 성공 확인

## 경계 케이스
- Memo content 빈 문자열 → 에러 (도메인 규칙)
- Archive title+body 빈 → 에러 전파
