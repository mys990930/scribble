# note-domain test

## Note
- 정상 생성 → 성공
- title 빈 문자열 → `NOTE_EMPTY_TITLE`
- body 빈 문자열 → 허용

## normalizeTags
- ["Foo", " bar ", "FOO", ""] → ["bar", "foo"]
- 빈 리스트 → 빈 리스트
- 공백만 있는 태그 → 제거

## 경계 케이스
- sourceType/sourceId 둘 다 null → 직접 생성 노트
- body에 Markdown 특수문자 → 그대로 보존 (렌더링은 UI 책임)
