from __future__ import annotations

import hashlib
import uuid
from dataclasses import dataclass
from datetime import UTC, datetime, timedelta

import jwt
from pwdlib import PasswordHash

from auth_session.errors import (
    email_already_exists,
    invalid_credentials,
    session_not_found,
    session_revoked,
    token_expired,
    token_invalid,
    user_disabled,
)
from auth_session.models import AuthSession, User, UserStatus
from auth_session.repository import AuthSessionRepository
from auth_session.schemas import (
    CurrentUserResponse,
    LoginRequest,
    RefreshRequest,
    RegisterRequest,
    TokenPairResponse,
    UserResponse,
)
from core.config import get_settings

password_hash = PasswordHash.recommended()


@dataclass(slots=True)
class AuthSessionService:
    repository: AuthSessionRepository

    async def register(self, payload: RegisterRequest) -> UserResponse:
        existing_user = await self.repository.get_user_by_email(payload.email)
        if existing_user is not None:
            raise email_already_exists()

        user = await self.repository.create_user(
            email=payload.email,
            password_hash=password_hash.hash(payload.password),
        )
        return UserResponse.model_validate(user)

    async def login(self, payload: LoginRequest) -> TokenPairResponse:
        user = await self.repository.get_user_by_email(payload.email)
        if user is None or not password_hash.verify(payload.password, user.password_hash):
            raise invalid_credentials()

        self._ensure_user_is_active(user)

        issued_at = datetime.now(tz=UTC)
        session_id = str(uuid.uuid4())
        refresh_token = self._encode_refresh_token(
            user_id=str(user.id),
            session_id=session_id,
            session_version=1,
            issued_at=issued_at,
        )
        auth_session = await self.repository.create_session(
            user_id=str(user.id),
            session_id=session_id,
            refresh_token_hash=self._hash_refresh_token(refresh_token),
            issued_at=issued_at,
            expires_at=issued_at + timedelta(days=get_settings().refresh_token_ttl_days),
        )
        await self.repository.update_user_last_login(user)
        return self._build_token_pair(user, auth_session, issued_at, refresh_token=refresh_token)

    async def refresh(self, payload: RefreshRequest) -> TokenPairResponse:
        token_payload = self._decode_token(payload.refresh_token, expected_type='refresh')
        session_id = token_payload.get('sid')
        user_id = token_payload.get('sub')
        version = token_payload.get('ver')
        if not session_id or not user_id or version is None:
            raise token_invalid()

        auth_session = await self.repository.get_session_by_id(str(session_id))
        if auth_session is None:
            raise session_not_found()
        self._ensure_session_is_active(auth_session)

        if str(auth_session.user_id) != str(user_id):
            raise token_invalid()
        if auth_session.session_version != int(version):
            raise token_invalid()
        if auth_session.refresh_token_hash != self._hash_refresh_token(payload.refresh_token):
            raise token_invalid()

        user = await self.repository.get_user_by_id(str(user_id))
        if user is None:
            raise invalid_credentials()
        self._ensure_user_is_active(user)

        issued_at = datetime.now(tz=UTC)
        next_version = auth_session.session_version + 1
        refresh_token = self._encode_refresh_token(
            user_id=str(user.id),
            session_id=str(auth_session.id),
            session_version=next_version,
            issued_at=issued_at,
        )
        auth_session = await self.repository.rotate_session(
            auth_session=auth_session,
            refresh_token_hash=self._hash_refresh_token(refresh_token),
            issued_at=issued_at,
            expires_at=issued_at + timedelta(days=get_settings().refresh_token_ttl_days),
        )
        return self._build_token_pair(user, auth_session, issued_at, refresh_token=refresh_token)

    async def logout(self, session_id: str | None) -> None:
        if session_id is None:
            raise token_invalid()
        await self.repository.revoke_session(session_id)

    async def get_current_user(self, user_id: str) -> CurrentUserResponse:
        user = await self.repository.get_user_by_id(user_id)
        if user is None:
            raise invalid_credentials()
        self._ensure_user_is_active(user)
        return CurrentUserResponse(user=UserResponse.model_validate(user))

    def _build_token_pair(
        self,
        user: User,
        auth_session: AuthSession,
        issued_at: datetime,
        refresh_token: str | None = None,
    ) -> TokenPairResponse:
        access_token = self._encode_access_token(
            user_id=str(user.id),
            session_id=str(auth_session.id),
            issued_at=issued_at,
        )
        if refresh_token is None:
            refresh_token = self._encode_refresh_token(
                user_id=str(user.id),
                session_id=str(auth_session.id),
                session_version=auth_session.session_version,
                issued_at=issued_at,
            )
        return TokenPairResponse(access_token=access_token, refresh_token=refresh_token)

    def _encode_access_token(self, user_id: str, session_id: str, issued_at: datetime) -> str:
        settings = get_settings()
        payload = {
            'sub': user_id,
            'sid': session_id,
            'type': 'access',
            'iat': int(issued_at.timestamp()),
            'exp': int((issued_at + timedelta(minutes=settings.access_token_ttl_minutes)).timestamp()),
        }
        return jwt.encode(payload, settings.jwt_secret, algorithm=settings.jwt_algorithm)

    def _encode_refresh_token(
        self,
        user_id: str,
        session_id: str,
        session_version: int,
        issued_at: datetime,
    ) -> str:
        settings = get_settings()
        payload = {
            'sub': user_id,
            'sid': session_id,
            'type': 'refresh',
            'ver': session_version,
            'iat': int(issued_at.timestamp()),
            'exp': int((issued_at + timedelta(days=settings.refresh_token_ttl_days)).timestamp()),
        }
        return jwt.encode(payload, settings.jwt_secret, algorithm=settings.jwt_algorithm)

    def _decode_token(self, token: str, expected_type: str) -> dict:
        settings = get_settings()
        try:
            payload = jwt.decode(token, settings.jwt_secret, algorithms=[settings.jwt_algorithm])
        except jwt.ExpiredSignatureError as exc:
            raise token_expired() from exc
        except jwt.PyJWTError as exc:
            raise token_invalid() from exc

        if payload.get('type') != expected_type:
            raise token_invalid()
        return payload

    def _hash_refresh_token(self, refresh_token: str) -> str:
        return hashlib.sha256(refresh_token.encode('utf-8')).hexdigest()

    def _ensure_session_is_active(self, auth_session: AuthSession) -> None:
        now = datetime.now(tz=UTC)
        if auth_session.revoked_at is not None:
            raise session_revoked()
        if auth_session.expires_at <= now:
            raise token_expired()

    def _ensure_user_is_active(self, user: User) -> None:
        if user.status != UserStatus.ACTIVE:
            raise user_disabled()
