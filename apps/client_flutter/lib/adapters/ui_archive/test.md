# ui-archive test

## ArchiveScreen
- 아카이브 3개 → 목록 표시
- 카테고리 필터 → 해당 카테고리만
- 검색어 입력 → 제목/본문/카테고리 부분일치 결과
- 빈 목록 → 빈 상태

## ArchiveShareCategorySheet
- pending share 존재 시 시트 오픈
- 기존 카테고리 목록이 최근 순으로 표시
- 기본 선택값은 최근 저장 카테고리
- `+ 새 카테고리` 선택 시에만 입력창 노출
- 카테고리 선택 후 handleIncoming 1회 호출
- 취소 시 handleIncoming 호출 없음
- 저장 성공 시 성공 피드백 + archive 목록 갱신
- 저장 실패 시 에러 표시 + 재시도 버튼 노출

## ArchiveDetailScreen
- title/body/category 수정 저장 가능
- 삭제 가능
- 저장 후 목록 갱신

## 경계 케이스
- imageUrl null → 이미지 미표시 (깨지지 않음)
- url null → 링크 텍스트 미표시
