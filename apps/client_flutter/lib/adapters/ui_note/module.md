# ui-note

## 목표

Note 기능의 Flutter 화면을 담당한다.

## 책임

- NoteScreen: 노트 목록, 검색
- 노트 편집/상세 화면 (Markdown 렌더링)

## 비책임

- Note 규칙 → `note-domain`
- CRUD/ingest → `note-usecases`
- 테마 → `shared/ui`

## 의존 모듈

- `note-usecases`
- `note-domain`
- `shared/ui`

## 의존 방향

```
ui_note → note_usecases, note_domain, shared/ui
ui_note ← app_shell
```
