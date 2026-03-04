# note-usecases contracts

## Repository 인터페이스

### NoteRepository (abstract)

| 메서드 | 설명 |
|---|---|
| listAll() → Future\<List\<Note\>\> | 전체 조회 |
| getById(String id) → Future\<Note?\> | 단건 조회 |
| save(Note) → Future\<void\> | 생성/수정 |
| delete(String id) → Future\<void\> | 삭제 |
| search(String query) → Future\<List\<Note\>\> | 검색 |

## Usecase

| 이름 | 입력 | 출력 | 설명 |
|---|---|---|---|
| ListNotes | — | List\<Note\> | 전체 목록 |
| CreateNote | title, body, tags | Note | 태그 정규화 후 저장 |
| UpdateNote | Note | void | 수정 |
| DeleteNote | noteId | void | 삭제 |
| IngestFromMemo | Memo | Note | Memo→Note 변환 저장 |
| IngestFromArchive | ArchiveEntry | Note | Archive→Note 변환 저장 |

## Ingest 규칙

### IngestFromMemo
- title: content 첫 줄 (50자 제한, 초과 시 truncate+"…")
- body: content 전체
- tags: ["from-memo"]
- sourceType: "memo", sourceId: memo.id

### IngestFromArchive
- title: archive.title
- body: archive.body + (url 있으면 원본 링크 append)
- tags: [archive.category, "from-archive"]
- sourceType: "archive", sourceId: archive.id
