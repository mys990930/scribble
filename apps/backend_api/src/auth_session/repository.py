from __future__ import annotations

import uuid
from datetime import UTC, datetime
from uuid import UUID

from sqlalchemy import Select, select
from sqlalchemy.ext.asyncio import AsyncSession

from auth_session.models import AuthSession, User


class AuthSessionRepository:
    def __init__(self, session: AsyncSession) -> None:
        self._session = session

    async def create_user(self, email: str, password_hash: str) -> User:
        user = User(email=email, password_hash=password_hash)
        self._session.add(user)
        await self._session.commit()
        await self._session.refresh(user)
        return user

    async def get_user_by_email(self, email: str) -> User | None:
        stmt: Select[tuple[User]] = select(User).where(User.email == email)
        return await self._session.scalar(stmt)

    async def get_user_by_id(self, user_id: str) -> User | None:
        stmt: Select[tuple[User]] = select(User).where(User.id == UUID(user_id))
        return await self._session.scalar(stmt)

    async def update_user_last_login(self, user: User) -> None:
        user.last_login_at = datetime.now(tz=UTC)
        await self._session.commit()

    async def create_session(
        self,
        user_id: str,
        refresh_token_hash: str,
        issued_at: datetime,
        expires_at: datetime,
        created_by_ip: str | None = None,
        user_agent: str | None = None,
        session_id: str | None = None,
    ) -> AuthSession:
        auth_session = AuthSession(
            id=UUID(session_id) if session_id else uuid.uuid4(),
            user_id=UUID(user_id),
            refresh_token_hash=refresh_token_hash,
            issued_at=issued_at,
            expires_at=expires_at,
            last_used_at=issued_at,
            created_by_ip=created_by_ip,
            user_agent=user_agent,
        )
        self._session.add(auth_session)
        await self._session.commit()
        await self._session.refresh(auth_session)
        return auth_session

    async def get_session_by_refresh_hash(self, refresh_token_hash: str) -> AuthSession | None:
        stmt: Select[tuple[AuthSession]] = select(AuthSession).where(
            AuthSession.refresh_token_hash == refresh_token_hash,
        )
        return await self._session.scalar(stmt)

    async def get_session_by_id(self, session_id: str) -> AuthSession | None:
        stmt: Select[tuple[AuthSession]] = select(AuthSession).where(AuthSession.id == UUID(session_id))
        return await self._session.scalar(stmt)

    async def rotate_session(
        self,
        auth_session: AuthSession,
        refresh_token_hash: str,
        issued_at: datetime,
        expires_at: datetime,
    ) -> AuthSession:
        auth_session.session_version += 1
        auth_session.refresh_token_hash = refresh_token_hash
        auth_session.issued_at = issued_at
        auth_session.expires_at = expires_at
        auth_session.last_used_at = issued_at
        auth_session.revoked_at = None
        auth_session.revoke_reason = None
        await self._session.commit()
        await self._session.refresh(auth_session)
        return auth_session

    async def revoke_session(self, session_id: str, reason: str = 'logout') -> None:
        auth_session = await self.get_session_by_id(session_id)
        if auth_session is None:
            return

        auth_session.revoked_at = datetime.now(tz=UTC)
        auth_session.revoke_reason = reason
        await self._session.commit()
