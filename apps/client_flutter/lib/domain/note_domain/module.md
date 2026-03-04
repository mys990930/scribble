# note-domain

## 목표

Note(장기 기록)의 순수 비즈니스 규칙을 정의한다.

## 책임

- Note 엔티티: id, title, body(Markdown), tags, 생성/수정 시각
- Note 본문 유효성 (빈 제목 불허)
- 태그 정규화 규칙 (소문자, trim, 중복 제거)

## 비책임

- 영속화 → `storage-sqlite`
- Memo/Archive 유입 정규화 → `note-usecases`
- UI 렌더링 → `ui-note`

## 의존 모듈

- `shared/kernel`

## 의존 방향

```
note_domain → shared/kernel (only)
note_domain ← note_usecases, ui_note, storage_sqlite
```
