# archive-domain contracts

## 엔티티

### ArchiveEntry

| 필드 | 타입 | 설명 |
|---|---|---|
| id | String (UUID) | 고유 식별자 |
| url | String? | 원본 URL |
| title | String | 제목 |
| body | String | 본문 텍스트 |
| imageUrl | String? | 수집된 대표 이미지 URL |
| category | String | 카테고리 |
| captureType | CaptureType | 수집 방식 |
| createdAt | DateTime | 생성 시각 |

### CaptureType

`full | fallback | manual`

- `full`: 수집(fetch) 성공으로 생성됨 (imageUrl은 null일 수 있음)
- `fallback`: 수집 실패 또는 URL 미존재 상태에서 원문 기반 저장
- `manual`: 사용자 직접 입력

## 에러

| 코드 | 설명 |
|---|---|
| `ARCHIVE_EMPTY_CONTENT` | title과 body 모두 빈 문자열 |
| `ARCHIVE_INVALID_CATEGORY` | 카테고리 빈 문자열 |
