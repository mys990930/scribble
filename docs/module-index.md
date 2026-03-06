# Module Index

## 전체 모듈 목록

### Shared (2)
| 모듈 | 위치 | 설명 |
|---|---|---|
| shared/kernel | `lib/shared/kernel/` | ID, Result, AppError, TimeUtils, EventBus |
| shared/ui | `lib/shared/ui/` | AppColors, 테마, 공통 UI |

### Domain Core (5)
| 모듈 | 위치 | 설명 |
|---|---|---|
| dailyplan-domain | `lib/domain/dailyplan_domain/` | Plan/Routine/Tag/시간 규칙 |
| calendar-domain | `lib/domain/calendar_domain/` | 캘린더 이벤트 규칙 |
| memo-domain | `lib/domain/memo_domain/` | Memo(Todo) 규칙 |
| note-domain | `lib/domain/note_domain/` | Note 규칙 |
| archive-domain | `lib/domain/archive_domain/` | Archive 수집 규칙 |

### Usecase / Orchestration (8)
| 모듈 | 위치 | 설명 |
|---|---|---|
| auth-usecases | `lib/usecases/auth_usecases/` | 로그인/로그아웃, 세션 복구, 인증 상태 제공 |
| settings-usecases | `lib/usecases/settings_usecases/` | 앱 설정 조회/저장 |
| dailyplan-usecases | `lib/usecases/dailyplan_usecases/` | Plan CRUD, 템플릿 관리 |
| calendar-usecases | `lib/usecases/calendar_usecases/` | 캘린더 CRUD, Memo→Calendar |
| memo-usecases | `lib/usecases/memo_usecases/` | Memo CRUD, 정렬, 알람, 전환 |
| note-usecases | `lib/usecases/note_usecases/` | Note CRUD, ingest |
| archive-usecases | `lib/usecases/archive_usecases/` | Share 수신, 수집, Archive→Note |
| sync | `lib/usecases/sync/` | 동기화 (outbox/inbox/conflict/cursor) |

### Platform Adapters — Client (16)
| 모듈 | 위치 | 설명 |
|---|---|---|
| app-shell | `lib/app_shell/` | 진입점, 라우팅, auth gate, **조건부 DI** (`di/`) |
| ui-main | `lib/adapters/ui_main/` | 앱 메인 허브 UI |
| ui-auth | `lib/adapters/ui_auth/` | 로그인/세션 복구/재인증 UI |
| ui-settings | `lib/adapters/ui_settings/` | 설정 UI |
| ui-dailyplan | `lib/adapters/ui_dailyplan/` | Daily Plan UI |
| ui-calendar | `lib/adapters/ui_calendar/` | Calendar UI |
| ui-memo | `lib/adapters/ui_memo/` | Memo UI |
| ui-note | `lib/adapters/ui_note/` | Note UI |
| ui-archive | `lib/adapters/ui_archive/` | Archive UI |
| share-intent | `lib/adapters/share_intent/` | OS 공유 payload 수신 후 archive-usecases로 전달 |
| widget-todo | `lib/adapters/widget_todo/` | Memo 위젯 (네이티브 전용) |
| widget-calendar | `lib/adapters/widget_calendar/` | Calendar 위젯 (네이티브 전용) |
| widget-dailyplan | `lib/adapters/widget_dailyplan/` | DailyPlan 위젯 (네이티브 전용) |
| storage-sqlite | `lib/adapters/storage_sqlite/` | Drift DB 구현 (네이티브 전용) |
| secure-storage | `lib/adapters/secure_storage/` | 토큰/세션 저장소 구현 |
| api-client | `lib/adapters/api_client/` | 백엔드 HTTP + 웹 CRUD + Auth API |

### Platform Adapters — Backend (3)
| 모듈 | 위치 | 설명 |
|---|---|---|
| auth-session | `backend_api/src/auth_session/` | 인증/세션 |
| device-registry | `backend_api/src/device_registry/` | 디바이스 등록 |
| sync-api | `backend_api/src/sync_api/` | 동기화 엔드포인트 |

---

## 플랫폼별 데이터 흐름

```
네이티브 (모바일/데스크톱):
  UI → MemoServiceImpl → DriftMemoRepository → SQLite
                                          ↕ (sync)
                                      서버 API

웹:
  UI → MemoServiceImpl → ApiMemoRepository → 서버 API (직접)
```

조건부 DI (`app_shell/di/`):
- `dart.library.io` → `di_native.dart` (DriftMemoRepository + secure-storage)
- `dart.library.js_interop` → `di_web.dart` (ApiMemoRepository + web storage)
- 컴파일 타임에 결정되어 웹 빌드에 dart:ffi 코드가 포함되지 않음

인증 게이트 흐름:
- App start → `ui-auth/AuthGate` → `auth-usecases.restoreSession()`
- 세션 유효: `ui-main` 진입
- 세션 무효: `ui-auth/Login` 진입

공유 브릿지 흐름:
- OS Share Intent → `adapters/share_intent` → `ui-archive` 카테고리 선택 → `archive-usecases(HandleShare)`

---

## 의존 관계 다이어그램

```mermaid
graph TD
    subgraph "Shared"
        K[shared/kernel]
        UI_S[shared/ui]
    end

    subgraph "Domain Core"
        DP_D[dailyplan-domain]
        CAL_D[calendar-domain]
        MEMO_D[memo-domain]
        NOTE_D[note-domain]
        ARC_D[archive-domain]
    end

    subgraph "Usecase / Orchestration"
        AUTH_U[auth-usecases]
        SET_U[settings-usecases]
        DP_U[dailyplan-usecases]
        CAL_U[calendar-usecases]
        MEMO_U[memo-usecases]
        NOTE_U[note-usecases]
        ARC_U[archive-usecases]
        SYNC[sync]
    end

    subgraph "Adapters — UI"
        UI_MAIN[ui-main]
        UI_AUTH[ui-auth]
        UI_SET[ui-settings]
        UI_DP[ui-dailyplan]
        UI_CAL[ui-calendar]
        UI_MEMO[ui-memo]
        UI_NOTE[ui-note]
        UI_ARC[ui-archive]
        SHARE[share-intent]
    end

    subgraph "Adapters — Widget"
        W_TODO[widget-todo]
        W_CAL[widget-calendar]
        W_DP[widget-dailyplan]
    end

    subgraph "Adapters — Infra"
        SHELL[app-shell + di/]
        SQLITE[storage-sqlite\n네이티브 전용]
        SECURE[secure-storage]
        API[api-client\nsync + auth + 웹 CRUD]
    end

    subgraph "Backend"
        B_AUTH[auth-session]
        B_DEV[device-registry]
        B_SYNC[sync-api]
    end

    %% Domain → Kernel
    DP_D --> K
    CAL_D --> K
    MEMO_D --> K
    NOTE_D --> K
    ARC_D --> K

    %% Usecases → Domain/Kernel
    AUTH_U --> K
    SET_U --> K
    DP_U --> DP_D
    CAL_U --> CAL_D
    MEMO_U --> MEMO_D
    NOTE_U --> NOTE_D
    ARC_U --> ARC_D
    DP_U --> K
    CAL_U --> K
    MEMO_U --> K
    NOTE_U --> K
    ARC_U --> K
    SYNC --> K

    %% Cross-usecase
    MEMO_U -.-> NOTE_U
    MEMO_U -.-> CAL_U
    ARC_U -.-> NOTE_U

    %% UI → Usecases + shared/ui
    UI_MAIN --> UI_S
    UI_MAIN -.route.-> UI_MEMO
    UI_MAIN -.route.-> UI_CAL
    UI_MAIN -.route.-> UI_DP
    UI_MAIN -.route.-> UI_NOTE
    UI_MAIN -.route.-> UI_ARC

    UI_AUTH --> AUTH_U
    UI_AUTH --> UI_S
    UI_SET --> SET_U
    UI_SET --> UI_S

    UI_DP --> DP_U
    UI_DP --> UI_S
    UI_CAL --> CAL_U
    UI_CAL --> UI_S
    UI_MEMO --> MEMO_U
    UI_MEMO --> UI_S
    UI_NOTE --> NOTE_U
    UI_NOTE --> UI_S
    UI_ARC --> ARC_U
    UI_ARC --> UI_S
    SHARE --> UI_ARC

    %% Widgets
    W_TODO --> MEMO_D
    W_CAL --> CAL_D
    W_DP --> DP_D

    %% Infra implements
    SQLITE -.implements.-> MEMO_U
    SQLITE -.implements.-> DP_U
    SQLITE -.implements.-> CAL_U
    SQLITE -.implements.-> NOTE_U
    SQLITE -.implements.-> ARC_U
    SQLITE -.implements.-> SYNC

    API -.implements.-> MEMO_U
    API -.implements.-> AUTH_U
    API -.implements.-> SYNC

    SECURE -.implements.-> AUTH_U

    %% App shell
    SHELL --> UI_MAIN
    SHELL --> UI_AUTH
    SHELL --> UI_SET
    SHELL --> UI_DP
    SHELL --> UI_CAL
    SHELL --> UI_MEMO
    SHELL --> UI_NOTE
    SHELL --> UI_ARC
    SHELL --> SYNC
    SHELL --> UI_S
    SHELL -.native.-> SQLITE
    SHELL -.native.-> SECURE
    SHELL -.web.-> API

    %% Backend
    API -->|HTTP| B_SYNC
    API -->|HTTP| B_AUTH
    API -->|HTTP| B_DEV
```

### 범례
- **실선 화살표**: 직접 의존 (import)
- **점선 화살표**: 인터페이스 구현/조건부 DI/라우팅 참조
- 기본 방향: `adapter → usecase → domain → shared`
