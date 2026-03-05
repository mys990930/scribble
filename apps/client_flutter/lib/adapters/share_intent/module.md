# share-intent

## 목표

OS Share Intent로 전달된 외부 공유 payload를 수신해 `archive-usecases`로 전달한다.

## 책임

- 플랫폼별 공유 payload 수신 (text/url)
- payload를 `SharedContent` 입력 규격으로 매핑
- 카테고리 선택 완료 후 `HandleShareUseCase` 호출 트리거
- 카테고리 확정 전에는 저장을 수행하지 않음

## 비책임

- Archive 도메인 규칙 검증 → `archive-domain`
- 수집(full/fallback) 판단 및 저장 → `archive-usecases`
- DB 저장 구현 → `storage-sqlite`
- Archive 목록/상세 UI → `ui-archive`

## 의존 모듈

- `archive-usecases`
- `shared/kernel`

## 의존 방향

```
share_intent → archive_usecases, shared/kernel
share_intent ← app_shell (초기화/DI), 플랫폼 런처
```
