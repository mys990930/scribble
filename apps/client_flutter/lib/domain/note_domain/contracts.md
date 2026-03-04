# note-domain contracts

## 엔티티

### Note

| 필드 | 타입 | 설명 |
|---|---|---|
| id | String (UUID) | 고유 식별자 |
| title | String | 제목 |
| body | String | 본문 (Markdown) |
| tags | List\<String\> | 태그 목록 |
| sourceType | String? | 원본 유형 (memo / archive / null) |
| sourceId | String? | 원본 ID |
| createdAt | DateTime | 생성 시각 |
| updatedAt | DateTime | 수정 시각 |

## 순수 함수

### normalizeTags(List\<String\>) → List\<String\>
- 소문자 변환, trim, 빈 문자열 제거, 중복 제거, 정렬

## 에러

| 코드 | 설명 |
|---|---|
| `NOTE_EMPTY_TITLE` | title 빈 문자열 |
| `NOTE_NOT_FOUND` | 조회 대상 없음 |
