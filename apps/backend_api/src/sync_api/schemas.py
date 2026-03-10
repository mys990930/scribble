from __future__ import annotations

from datetime import datetime
from typing import Any
from uuid import UUID

from pydantic import BaseModel, Field


class SyncEventEnvelope(BaseModel):
    event_id: UUID
    entity_type: str = Field(min_length=1, max_length=40)
    entity_id: UUID
    operation: str = Field(pattern='^(upsert|delete)$')
    payload: dict[str, Any]
    updated_at: datetime
    deleted_at: datetime | None = None


class PushRequest(BaseModel):
    events: list[SyncEventEnvelope]


class PushResponse(BaseModel):
    accepted: int
    rejected: int
    server_cursor: str


class PullResponse(BaseModel):
    events: list[SyncEventEnvelope]
    next_cursor: str | None = None
    has_more: bool = False
