from __future__ import annotations

from datetime import datetime
from uuid import UUID

from pydantic import BaseModel, ConfigDict, Field


class RegisterDeviceRequest(BaseModel):
    device_id: str = Field(min_length=1, max_length=128)
    platform: str = Field(min_length=1, max_length=20)
    name: str = Field(min_length=1, max_length=120)
    app_version: str | None = Field(default=None, max_length=40)


class DevicePayload(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: UUID
    device_id: str
    platform: str
    name: str
    app_version: str | None = None
    is_active: bool
    last_seen_at: datetime | None = None
    last_sync_at: datetime | None = None


class DeviceResponse(BaseModel):
    device: DevicePayload


class DeviceListResponse(BaseModel):
    devices: list[DevicePayload]


class DeactivateDeviceResponse(BaseModel):
    device_id: str
    deactivated: bool
