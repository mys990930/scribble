"""initial schema"""

from __future__ import annotations

from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql

revision = '20260309_0001'
down_revision = None
branch_labels = None
depends_on = None


user_status_check = "status in ('active', 'disabled')"
device_platform_check = "platform in ('ios', 'android', 'windows', 'macos', 'linux', 'web')"
sync_operation_check = "operation in ('upsert', 'delete')"
sync_deleted_at_check = (
    "(operation = 'delete' and deleted_at is not null) or "
    "(operation = 'upsert' and deleted_at is null)"
)


def upgrade() -> None:
    op.execute('CREATE EXTENSION IF NOT EXISTS citext')

    op.create_table(
        'users',
        sa.Column('id', postgresql.UUID(as_uuid=True), primary_key=True, nullable=False),
        sa.Column('email', postgresql.CITEXT(), nullable=False),
        sa.Column('password_hash', sa.Text(), nullable=False),
        sa.Column('status', sa.String(length=20), nullable=False, server_default='active'),
        sa.Column('last_login_at', sa.DateTime(timezone=True), nullable=True),
        sa.Column('created_at', sa.DateTime(timezone=True), nullable=False, server_default=sa.text('now()')),
        sa.Column('updated_at', sa.DateTime(timezone=True), nullable=False, server_default=sa.text('now()')),
        sa.Column('deleted_at', sa.DateTime(timezone=True), nullable=True),
        sa.CheckConstraint(user_status_check, name='ck_users_users_status_valid'),
    )
    op.create_index('ix_users_status', 'users', ['status'])
    op.create_index('uq_users_email', 'users', ['email'], unique=True)

    op.create_table(
        'auth_sessions',
        sa.Column('id', postgresql.UUID(as_uuid=True), primary_key=True, nullable=False),
        sa.Column('user_id', postgresql.UUID(as_uuid=True), nullable=False),
        sa.Column('refresh_token_hash', sa.Text(), nullable=False),
        sa.Column('session_version', sa.Integer(), nullable=False, server_default='1'),
        sa.Column('issued_at', sa.DateTime(timezone=True), nullable=False),
        sa.Column('expires_at', sa.DateTime(timezone=True), nullable=False),
        sa.Column('last_used_at', sa.DateTime(timezone=True), nullable=True),
        sa.Column('revoked_at', sa.DateTime(timezone=True), nullable=True),
        sa.Column('revoke_reason', sa.String(length=50), nullable=True),
        sa.Column('created_by_ip', postgresql.INET(), nullable=True),
        sa.Column('user_agent', sa.Text(), nullable=True),
        sa.Column('created_at', sa.DateTime(timezone=True), nullable=False, server_default=sa.text('now()')),
        sa.Column('updated_at', sa.DateTime(timezone=True), nullable=False, server_default=sa.text('now()')),
        sa.ForeignKeyConstraint(['user_id'], ['users.id'], ondelete='CASCADE', name='fk_auth_sessions_user_id_users'),
        sa.CheckConstraint('expires_at > issued_at', name='ck_auth_sessions_auth_sessions_expires_after_issue'),
        sa.CheckConstraint(
            'revoked_at is null or revoked_at >= issued_at',
            name='ck_auth_sessions_auth_sessions_revoked_after_issue',
        ),
    )
    op.create_index('ix_auth_sessions_user_expires', 'auth_sessions', ['user_id', 'expires_at'])
    op.create_index('ix_auth_sessions_user_revoked', 'auth_sessions', ['user_id', 'revoked_at'])
    op.create_index(
        'uq_auth_sessions_refresh_token_hash',
        'auth_sessions',
        ['refresh_token_hash'],
        unique=True,
    )

    op.create_table(
        'devices',
        sa.Column('id', postgresql.UUID(as_uuid=True), primary_key=True, nullable=False),
        sa.Column('user_id', postgresql.UUID(as_uuid=True), nullable=False),
        sa.Column('device_id', sa.String(length=128), nullable=False),
        sa.Column('platform', sa.String(length=20), nullable=False),
        sa.Column('name', sa.String(length=120), nullable=False),
        sa.Column('app_version', sa.String(length=40), nullable=True),
        sa.Column('last_ip', postgresql.INET(), nullable=True),
        sa.Column('last_user_agent', sa.Text(), nullable=True),
        sa.Column('registered_at', sa.DateTime(timezone=True), nullable=False, server_default=sa.text('now()')),
        sa.Column('last_seen_at', sa.DateTime(timezone=True), nullable=True),
        sa.Column('last_sync_at', sa.DateTime(timezone=True), nullable=True),
        sa.Column('deactivated_at', sa.DateTime(timezone=True), nullable=True),
        sa.Column('created_at', sa.DateTime(timezone=True), nullable=False, server_default=sa.text('now()')),
        sa.Column('updated_at', sa.DateTime(timezone=True), nullable=False, server_default=sa.text('now()')),
        sa.ForeignKeyConstraint(['user_id'], ['users.id'], ondelete='CASCADE', name='fk_devices_user_id_users'),
        sa.CheckConstraint(device_platform_check, name='ck_devices_devices_platform_valid'),
        sa.CheckConstraint(
            'deactivated_at is null or deactivated_at >= registered_at',
            name='ck_devices_devices_deactivated_after_registered',
        ),
    )
    op.create_index('ix_devices_user_deactivated', 'devices', ['user_id', 'deactivated_at'])
    op.create_index('ix_devices_user_last_sync', 'devices', ['user_id', 'last_sync_at'])
    op.create_index('uq_devices_user_device_id', 'devices', ['user_id', 'device_id'], unique=True)

    op.create_table(
        'sync_events',
        sa.Column('id', postgresql.UUID(as_uuid=True), primary_key=True, nullable=False),
        sa.Column('event_id', postgresql.UUID(as_uuid=True), nullable=False),
        sa.Column('user_id', postgresql.UUID(as_uuid=True), nullable=False),
        sa.Column('device_pk', postgresql.UUID(as_uuid=True), nullable=False),
        sa.Column('device_id', sa.String(length=128), nullable=False),
        sa.Column('entity_type', sa.String(length=40), nullable=False),
        sa.Column('entity_id', postgresql.UUID(as_uuid=True), nullable=False),
        sa.Column('operation', sa.String(length=20), nullable=False),
        sa.Column('payload', postgresql.JSONB(astext_type=sa.Text()), nullable=False),
        sa.Column('updated_at', sa.DateTime(timezone=True), nullable=False),
        sa.Column('deleted_at', sa.DateTime(timezone=True), nullable=True),
        sa.Column('recorded_at', sa.DateTime(timezone=True), nullable=False, server_default=sa.text('now()')),
        sa.Column('created_at', sa.DateTime(timezone=True), nullable=False, server_default=sa.text('now()')),
        sa.ForeignKeyConstraint(['device_pk'], ['devices.id'], ondelete='CASCADE', name='fk_sync_events_device_pk_devices'),
        sa.ForeignKeyConstraint(['user_id'], ['users.id'], ondelete='CASCADE', name='fk_sync_events_user_id_users'),
        sa.CheckConstraint(sync_operation_check, name='ck_sync_events_sync_events_operation_valid'),
        sa.CheckConstraint(sync_deleted_at_check, name='ck_sync_events_sync_events_deleted_at_matches_operation'),
    )
    op.create_index('ix_sync_events_device_recorded', 'sync_events', ['device_pk', 'recorded_at'])
    op.create_index(
        'ix_sync_events_entity_lww',
        'sync_events',
        ['user_id', 'entity_type', 'entity_id', 'updated_at', 'recorded_at'],
    )
    op.create_index('ix_sync_events_user_recorded', 'sync_events', ['user_id', 'recorded_at', 'event_id'])
    op.create_index('uq_sync_events_event_id', 'sync_events', ['event_id'], unique=True)


def downgrade() -> None:
    op.drop_index('uq_sync_events_event_id', table_name='sync_events')
    op.drop_index('ix_sync_events_user_recorded', table_name='sync_events')
    op.drop_index('ix_sync_events_entity_lww', table_name='sync_events')
    op.drop_index('ix_sync_events_device_recorded', table_name='sync_events')
    op.drop_table('sync_events')

    op.drop_index('uq_devices_user_device_id', table_name='devices')
    op.drop_index('ix_devices_user_last_sync', table_name='devices')
    op.drop_index('ix_devices_user_deactivated', table_name='devices')
    op.drop_table('devices')

    op.drop_index('uq_auth_sessions_refresh_token_hash', table_name='auth_sessions')
    op.drop_index('ix_auth_sessions_user_revoked', table_name='auth_sessions')
    op.drop_index('ix_auth_sessions_user_expires', table_name='auth_sessions')
    op.drop_table('auth_sessions')

    op.drop_index('uq_users_email', table_name='users')
    op.drop_index('ix_users_status', table_name='users')
    op.drop_table('users')
