from sqlalchemy.ext.asyncio import AsyncSession

from auth_session.models import AuthSession, User


class AuthSessionRepository:
    def __init__(self, session: AsyncSession) -> None:
        self._session = session

    async def create_user(self, email: str, password_hash: str) -> User:
        raise NotImplementedError

    async def get_user_by_email(self, email: str) -> User | None:
        raise NotImplementedError

    async def get_user_by_id(self, user_id: str) -> User | None:
        raise NotImplementedError

    async def create_session(self, user_id: str, refresh_token_hash: str) -> AuthSession:
        raise NotImplementedError

    async def get_session_by_refresh_hash(self, refresh_token_hash: str) -> AuthSession | None:
        raise NotImplementedError

    async def revoke_session(self, session_id: str) -> None:
        raise NotImplementedError
