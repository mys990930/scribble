# Recent Context

## Working Rules

- This project is document-first SDD.
- Before implementing, read the module's `module.md`, `contracts.md`, and `test.md`.
- If code and docs diverge, update docs together with code.
- Preserve module boundaries. Do not casually move responsibilities across modules.

## Backend Status

Backend path:
- [`apps/backend_api`](/Users/konn/_dev/scribble/apps/backend_api)

Implemented:
- `auth_session`
- `device_registry`
- `sync_api`
- FastAPI app scaffold
- Alembic setup and initial schema
- backend tests for auth/device/sync
- Docker/NAS deployment files

Important backend notes:
- Backend sync contract uses opaque cursor strings.
- Sync request headers:
  - `Authorization: Bearer <access_token>`
  - `X-Device-Id: <device_id>`
- Device registration must happen before sync.
- NAS image currently uses baked-in env defaults in Dockerfile for this deployment path.

## Client Status

Client path:
- [`apps/client_flutter`](/Users/konn/_dev/scribble/apps/client_flutter)

Implemented:
1. Real auth integration
- `ApiAuthService`
- Android secure session persistence via `flutter_secure_storage`
- login -> session save -> device registration bootstrap

2. Device bootstrap
- persistent install-scoped `device.id`
- Android device metadata lookup
- `/devices` registration after successful login

3. Sync skeleton
- `ApiSyncRemote`
- sync DTOs/interfaces in `usecases/sync`
- `SyncUsecaseImpl.runOnce()`
- `DriftSyncStorage`
- Drift tables:
  - `sync_outbox`
  - `sync_cursor_entries`
- app start/resume triggers `runOnce()`

## What Is Still Missing

These are the main unfinished sync pieces:

1. `DriftSyncStorage.applyChanges()` is still a no-op
- pull succeeds
- cursor updates
- but pulled changes are not yet applied to local domain data

2. Outbox enqueue path is missing
- local memo/archive/etc writes do not automatically create `sync_outbox` events

3. Sync visibility/retry policy is minimal
- current behavior is best-effort
- no meaningful sync status UI/logging yet

## Recommended Next Step

Do not start with broad refactoring.

Recommended order:
1. `memo` outbox enqueue
2. `memo` applyChanges implementation
3. then expand to other domains

Reason:
- `memo` is the most implemented domain end-to-end
- drift repository/DAO already exist
- best first vertical slice for real sync

## Important Document State

Recently aligned docs:
- [`apps/client_flutter/lib/app_shell/module.md`](/Users/konn/_dev/scribble/apps/client_flutter/lib/app_shell/module.md)
- [`apps/client_flutter/lib/usecases/sync/module.md`](/Users/konn/_dev/scribble/apps/client_flutter/lib/usecases/sync/module.md)
- [`apps/client_flutter/lib/usecases/sync/contracts.md`](/Users/konn/_dev/scribble/apps/client_flutter/lib/usecases/sync/contracts.md)
- [`apps/client_flutter/lib/adapters/storage_sqlite/module.md`](/Users/konn/_dev/scribble/apps/client_flutter/lib/adapters/storage_sqlite/module.md)
- [`apps/client_flutter/lib/adapters/storage_sqlite/contracts.md`](/Users/konn/_dev/scribble/apps/client_flutter/lib/adapters/storage_sqlite/contracts.md)

Make sure future code changes keep these in sync.

## Orchestration Note

- `app_shell` being the orchestration owner is intentional.
- `_WidgetSyncGate` currently handles:
  - pending widget memo consume
  - pending share consume
  - server sync trigger
  - widget sync
- This is acceptable for now.
- Do not prioritize refactoring this before making sync real.
- If responsibilities continue to grow, split it later.

## TODO Reference

Sync backlog is also recorded in:
- [`TODO.md`](/Users/konn/_dev/scribble/TODO.md)

## Run Context

For Android real-device testing:

```bash
flutter run \
  --dart-define=SCRIBBLE_USE_REAL_AUTH=true \
  --dart-define=SCRIBBLE_API_BASE_URL=http://noum.iptime.org:8888
```

## Recent Commits Before This Handoff

- `214daa1` `Add client auth device bootstrap and backend sync scaffold`
- `53a5bfd` `Ignore generated build artifacts and image tar files`
