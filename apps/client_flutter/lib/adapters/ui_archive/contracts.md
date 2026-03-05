# ui-archive contracts

## 화면

### ArchiveScreen
- 전체/카테고리별 목록
- 탭 → 상세 화면
- 스와이프/버튼 → Note로 전송

### ArchiveShareCategorySheet (신규)
- 외부 공유 payload 수신 직후 표시
- 카테고리 선택 후 저장 실행
- 취소 시 저장하지 않고 화면 복귀

## 외부 공유 진입 플로우

1. app_shell이 `consumePendingShare()` 호출
2. pending payload가 있으면 `ArchiveShareCategorySheet` 오픈
3. 사용자가 카테고리 선택
4. `share-intent` adapter의 `handleIncoming(..., category)` 호출
5. 성공 시 ArchiveScreen으로 이동 + 저장 성공 피드백
6. 실패 시 에러 메시지 + 재시도 가능
