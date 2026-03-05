# ui-archive contracts

## 화면

### ArchiveScreen
- 전체/카테고리별 목록
- 검색(제목/본문/카테고리 contains)
- 탭 → 상세 화면

### ArchiveDetailScreen
- title/body/category 수정 저장
- 삭제
- url/imageUrl/captureType/createdAt는 읽기 중심 표시

### ArchiveShareCategorySheet
- 외부 공유 payload 수신 직후 표시
- 기존 카테고리 목록(최근 사용 순) 클릭 선택
- `+ 새 카테고리`에서만 직접 입력
- 기본 선택값은 최근 저장 카테고리
- 취소 시 저장하지 않고 화면 복귀

## 외부 공유 진입 플로우

1. app_shell이 `consumePendingShare()` 호출
2. pending payload가 있으면 `ArchiveShareCategorySheet` 오픈
3. 사용자가 카테고리 선택/추가
4. `share-intent` adapter의 `handleIncoming(..., category)` 호출
5. 성공 시 ArchiveScreen으로 이동 + 저장 성공 피드백 + 목록 갱신
6. 실패 시 에러 메시지 + 재시도 가능
