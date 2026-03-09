from datetime import datetime

from pydantic import BaseModel, Field


class SyncEventEnvelope(BaseModel):
    event_id: str
    entity_type: str = Field(min_length=1, max_length=40)
    entity_id: str
    operation: str = Field(pattern='^(upsert|delete)$')
    payload: dict
    updated_at: datetime
    deleted_at: datetime | None = None


class PushRequest(BaseModel):
    device_id: str = Field(min_length=1, max_length=128)
    events: list[SyncEventEnvelope]


class PushResponse(BaseModel):
    accepted: int
    rejected: int
    server_cursor: str


class PullResponse(BaseModel):
    events: list[SyncEventEnvelope]
    next_cursor: str | None = None
    has_more: bool = False
