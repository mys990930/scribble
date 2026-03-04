# note-usecases

## 목표

Note CRUD와 Memo/Archive에서 유입되는 콘텐츠 정규화(ingest) 흐름을 조율한다.

## 책임

- Note CRUD
- Memo→Note 수신: content를 title/body로 분리, 태그 자동 부여
- Archive→Note 수신: archive 메타 → Note 변환
- 저장소 인터페이스 정의 (NoteRepository abstract class)

## 비책임

- 비즈니스 규칙 → `note-domain`
- 전환 발신 (Memo→Note 흐름 시작) → `memo-usecases`
- DB 구현 → `storage-sqlite`
- UI → `ui-note`

## 의존 모듈

- `note-domain`
- `memo-domain` (Memo 타입 참조)
- `archive-domain` (ArchiveEntry 타입 참조)
- `shared/kernel`

## 의존 방향

```
note_usecases → note_domain, memo_domain, archive_domain, shared/kernel
note_usecases ← ui_note, memo_usecases(calls), archive_usecases(calls), storage_sqlite
```
