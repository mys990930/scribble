from __future__ import annotations

from dataclasses import dataclass
from datetime import UTC, datetime, timedelta

from core.config import get_settings
from core.errors import AppError


@dataclass(slots=True)
class CursorState:
    recorded_at: datetime
    event_id: str


def encode_cursor(state: CursorState) -> str:
    return f'{state.recorded_at.astimezone(UTC).isoformat()}::{state.event_id}'


def decode_cursor(cursor: str) -> CursorState:
    try:
        recorded_at_raw, event_id = cursor.split('::', maxsplit=1)
        recorded_at = datetime.fromisoformat(recorded_at_raw)
    except ValueError as exc:
        raise AppError(code='CURSOR_EXPIRED', message='Invalid cursor', status_code=410) from exc
    return CursorState(recorded_at=recorded_at, event_id=event_id)


def ensure_cursor_not_expired(state: CursorState) -> None:
    ttl_days = get_settings().sync_cursor_ttl_days
    if state.recorded_at < datetime.now(tz=UTC) - timedelta(days=ttl_days):
        raise AppError(code='CURSOR_EXPIRED', message='Cursor has expired', status_code=410)
