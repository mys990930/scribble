from dataclasses import dataclass

from pwdlib import PasswordHash

from auth_session.repository import AuthSessionRepository
from auth_session.schemas import (
    CurrentUserResponse,
    LoginRequest,
    RefreshRequest,
    RegisterRequest,
    TokenPairResponse,
    UserResponse,
)

password_hash = PasswordHash.recommended()


@dataclass(slots=True)
class AuthSessionService:
    repository: AuthSessionRepository

    async def register(self, payload: RegisterRequest) -> UserResponse:
        raise NotImplementedError

    async def login(self, payload: LoginRequest) -> TokenPairResponse:
        raise NotImplementedError

    async def refresh(self, payload: RefreshRequest) -> TokenPairResponse:
        raise NotImplementedError

    async def logout(self, session_id: str | None) -> None:
        raise NotImplementedError

    async def get_current_user(self, user_id: str) -> CurrentUserResponse:
        raise NotImplementedError
