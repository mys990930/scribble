# Scribble — Modular Offline-First Personal Productivity Platform

> Scribble은 Memo(Todo), Calendar, Daily Plan, Note, Archive를 통합한 개인 생산성 앱이다.  
> Flutter 멀티플랫폼(Windows/Web/iOS 포함) + 백엔드 동기화를 전제로, **로컬 우선(offline-first)** 과 **철저한 모듈 경계**를 핵심 원칙으로 설계한다.

---

## 1) 제품 목표

- **즉시성:** 네트워크 상태와 무관하게 로컬에서 즉시 입력/수정/조회
- **일상 실행력:** Daily Plan 기반으로 하루 루틴을 시간축에서 관리
- **기록 연계:** Memo ↔ Calendar ↔ Note, Archive → Note 흐름 통합
- **수집 자동화:** 외부 공유(Share)로 즉시 Archive 저장
- **다기기 일관성:** 계정 기반 멀티디바이스 동기화
- **확장 가능한 구조:** 굵은 단위 모듈로 시작, 크기 관리 규칙에 따라 분리

---

## 2) 핵심 기능 정의

## 2.1 Daily Plan

- 기상~취침까지의 루틴 타임라인 관리
- Routine은 **10분 단위**로 생성/수정
- Routine **겹침 허용**
- 진행 중 Routine은 **현재 시간 기반 자동 판정**
- Quick Tag는 **고정 + 커스텀 허용**
  - 고정: Work / Rest / Sleep
  - 커스텀 태그 추가 가능
- 요일별 Plan 템플릿 지원
- Plan 진행률 / Routine 진행률 계산 및 시각화

## 2.2 Calendar (내부 전용)

- 앱 내부 캘린더(일/주/월 조회)
- 외부 캘린더 연동(예: Google Calendar)은 v1 비대상
- Memo에서 Calendar로 일정 전환 가능
- Daily Plan 기반 일정 표현 가능

## 2.3 Memo (Todo)

- 빠른 캡처/수정/정렬/기한 관리
- Memo → Note 전송
- Memo → Calendar 전송

## 2.4 Note

- 장기 기록 저장소 (Markdown 중심)
- Memo/Archive에서 유입된 콘텐츠 정리

## 2.5 Archive

- 외부 앱 공유(Share Intent) 수신 엔드포인트
- 카테고리 선택 후 즉시 저장
- 경량 수집:
  - 1순위: URL + 이미지 수집
  - 폴백: 링크 + 본문 텍스트 저장
- Archive → Note 전송

## 2.6 Widgets

- 위젯 우선순위: **Todo > Calendar > DailyPlan**
- v1 위젯은 **읽기 전용(상호작용 없음)**
- 기능별 위젯 모듈 분리(각각 독립 개발 가능)

---

## 3) 아키텍처 원칙

## 3.1 Offline-First + Sync

- 클라이언트 SoT는 로컬 DB(SQLite)
- UI는 로컬 상태 기준으로 렌더링
- 동기화는 별도 Sync 모듈이 비동기 처리

## 3.1.1 웹 플랫폼 데이터 전략

- 웹에서는 SQLite(dart:ffi) 사용 불가 → **서버 API 직접 호출**로 fallback
- `app_shell/di/`에서 조건부 import(`dart.library.io` / `dart.library.js_interop`)로 컴파일 타임 분기
- 네이티브: `DriftMemoService` (SQLite, offline-first)
- 웹: `ApiMemoService` (HTTP, 서버 의존)
- UI 코드는 `MemoService` 인터페이스만 참조하므로 플랫폼 차이를 인지하지 않음
- MethodChannel 기반 위젯 동기화도 `kIsWeb` 가드로 웹에서 비활성

## 3.2 Layered + Modular

전체 구조는 3계층으로 고정한다.

1. **Domain Core**: 순수 비즈니스 규칙 (플랫폼 독립)
2. **Usecase/Orchestration**: 유스케이스 조합, 모듈 간 흐름 제어
3. **Platform Adapters**: Flutter UI, 위젯, DB, API, 백엔드 엔드포인트

## 3.3 의존 방향 강제

- `ui-*`, `widget-*` → `*-usecases` → `domain core`
- `domain core`는 adapter를 절대 참조하지 않음
- 기능 간 직접 결합 금지 (usecase 계층을 통해서만 연동)

## 3.4 모듈 간 통신 패턴

- 동일 계층 모듈 간 직접 import 금지
- 모듈 간 연동은 **usecase 계층에서 인터페이스(abstract class) 주입**으로 처리
- 비동기 이벤트가 필요한 경우 `shared/kernel`의 이벤트 버스를 통해 발행/구독
- 교차 관심사 계약(sync protocol, event envelope, error model)은 `docs/contracts/`에 정의

## 3.5 문서 위치 원칙

- 모듈 설계 문서(`module.md`, `contracts.md`, `test.md`)는 **코드 디렉토리 안에** 배치
- `docs/contracts/`는 **모듈 간 공유 프로토콜** 전용 (sync protocol, event envelope, error model)
- 모듈 자체 DTO/에러는 해당 모듈의 `contracts.md`에만 기술

---

## 4) 모듈 분해 (v1 기준)

> **원칙:** 굵게 시작하고, §8 크기 관리 규칙 트리거 시 분리한다.

## 4.1 Domain Core

- `dailyplan-domain`
  - 태그 정책(고정/커스텀, color), 10분 단위 시간 정규화
  - 요일별 템플릿, 날짜별 플랜 인스턴스
  - Routine 배치/수정/겹침 허용, 현재 시간 기준 진행률 판정
- `calendar-domain`
  - 내부 캘린더 이벤트 규칙
- `memo-domain`
  - Todo 규칙
- `note-domain`
  - 노트 메타/본문/버전 규칙
- `archive-domain`
  - 아카이브 엔트리/카테고리/소스 규칙

## 4.2 Usecase / Orchestration

- `dailyplan-usecases`
  - 템플릿 관리, 오늘 플랜 생성/편집
- `calendar-usecases`
  - 캘린더 CRUD/조회
- `memo-usecases`
  - Memo CRUD, Memo→Note·Memo→Calendar 흐름
- `note-usecases`
  - Note CRUD, Memo/Archive 유입 콘텐츠 정규화(ingest)
- `archive-usecases`
  - Share 수신 처리, URL+이미지 수집, 폴백, Archive→Note 흐름
- `sync`
  - Outbox push, Inbox pull, Cursor 기반 증분 동기화, LWW 충돌 해결

## 4.3 Platform Adapters

### Client
- `app-shell` — 앱 진입점, 라우팅, DI
- `ui-dailyplan`
- `ui-calendar`
- `ui-memo`
- `ui-note`
- `ui-archive`
- `share-intent` — OS 공유(Share Intent) 수신 bridge adapter, payload를 archive-usecases로 전달
- `widget-todo`
- `widget-calendar`
- `widget-dailyplan`
- `storage-sqlite`
- `api-client`

### Backend
- `auth-session` — 인증/세션
- `device-registry` — 디바이스 등록/관리
- `sync-api` — 동기화 엔드포인트 (모든 도메인 데이터의 sync 중계)

> **Backend 참고:** v1에서 클라이언트 데이터 CRUD는 로컬 우선이며, 백엔드는 sync-api를 통해 동기화만 담당한다.
> 도메인별 서버사이드 API(dailyplan-api, memo-api 등)는 서버사이드 로직이 필요해지는 시점에 추가한다.

---

## 5) 사용자 플로우 (E2E)

1. 로그인/디바이스 등록 → 초기 데이터 동기화
2. 요일 템플릿 설정 → 오늘 Daily Plan 인스턴스 생성
3. Routine 실행 상태는 시간 자동 판정, 진행률 계산
4. Memo 캡처 → 필요 시 Calendar 일정 또는 Note로 전송
5. 외부 앱 공유 → Archive 저장(수집/폴백) → 필요 시 Note로 전송
6. 모든 변경은 로컬 저장 후 Sync 모듈이 멀티디바이스 반영

---

## 6) 동기화 전략 (v1)

- 로컬 write 우선
- Outbox push + Inbox pull
- Cursor 기반 증분 동기화
- 충돌 해결: 기본 LWW
- 삭제는 tombstone(soft delete) 우선

---

## 7) 모듈 문서 규칙 (강제)

모든 모듈은 코드 디렉토리 안에 아래 3개 문서를 반드시 포함한다.

1. `module.md`
   - 목표 유스케이스
   - 책임 / 비책임
   - 의존 모듈 및 허용 방향

2. `contracts.md`
   - 입출력 타입(DTO)
   - 에러 모델 및 코드
   - 이벤트/명령 계약

3. `test.md`
   - 호출 예시
   - 회귀/호환성 보장 케이스
   - 경계/실패 케이스

---

## 8) 모듈 크기 관리 규칙

다음 조건 중 하나를 넘기면 모듈을 분리한다.

- 유스케이스 7개 초과
- 계약 DTO/에러 30개 초과
- test 필수 케이스 20개 초과
- 외부 모듈 의존 4개 초과

목표는 "모듈 하나 = 한 번에 이해 가능한 문맥"을 유지하는 것이다.

---

## 9) v1 범위

v1에서 아래 기능은 모두 포함한다.

- Daily Plan / Calendar / Memo / Note / Archive
- 기능별 위젯(Todo, Calendar, DailyPlan)
- 멀티플랫폼 클라이언트 + 백엔드 동기화
- 모듈 3문서(`module.md`, `contracts.md`, `test.md`) 의무화

---

## 10) 비목표 (v1)

- 외부 캘린더 연동
- 위젯 상호작용(쓰기/완료 처리)
- 고급 실시간 협업 편집
- CRDT 기반 고급 병합
- 도메인별 서버사이드 API (sync-api로 충분한 동안)

v1은 개인 사용 시나리오에서의 안정적 실행/기록/동기화 완성도에 집중한다.
