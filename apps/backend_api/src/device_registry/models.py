from __future__ import annotations

import uuid
from datetime import datetime
from enum import StrEnum

from sqlalchemy import CheckConstraint, ForeignKey, Index, String, Text
from sqlalchemy.dialects.postgresql import INET, UUID
from sqlalchemy.orm import Mapped, mapped_column

from core.database import Base, TimestampMixin, UUIDPrimaryKeyMixin


class DevicePlatform(StrEnum):
    IOS = 'ios'
    ANDROID = 'android'
    WINDOWS = 'windows'
    MACOS = 'macos'
    LINUX = 'linux'
    WEB = 'web'


class Device(UUIDPrimaryKeyMixin, TimestampMixin, Base):
    __tablename__ = 'devices'
    __table_args__ = (
        Index('uq_devices_user_device_id', 'user_id', 'device_id', unique=True),
        Index('ix_devices_user_deactivated', 'user_id', 'deactivated_at'),
        Index('ix_devices_user_last_sync', 'user_id', 'last_sync_at'),
        CheckConstraint(
            "platform in ('ios', 'android', 'windows', 'macos', 'linux', 'web')",
            name='devices_platform_valid',
        ),
        CheckConstraint(
            'deactivated_at is null or deactivated_at >= registered_at',
            name='devices_deactivated_after_registered',
        ),
    )

    user_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey('users.id', ondelete='CASCADE'),
        nullable=False,
    )
    device_id: Mapped[str] = mapped_column(String(128), nullable=False)
    platform: Mapped[str] = mapped_column(String(20), nullable=False)
    name: Mapped[str] = mapped_column(String(120), nullable=False)
    app_version: Mapped[str | None] = mapped_column(String(40), nullable=True)
    last_ip: Mapped[str | None] = mapped_column(INET, nullable=True)
    last_user_agent: Mapped[str | None] = mapped_column(Text, nullable=True)
    registered_at: Mapped[datetime] = mapped_column(nullable=False)
    last_seen_at: Mapped[datetime | None] = mapped_column(nullable=True)
    last_sync_at: Mapped[datetime | None] = mapped_column(nullable=True)
    deactivated_at: Mapped[datetime | None] = mapped_column(nullable=True)
