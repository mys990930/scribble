from dataclasses import dataclass
from typing import Annotated

import jwt
from fastapi import Depends, Header

from auth_session.errors import token_expired, token_invalid
from core.config import get_settings
from core.errors import AppError


@dataclass(slots=True)
class AuthContext:
    user_id: str
    session_id: str | None


@dataclass(slots=True)
class DeviceContext:
    user_id: str
    session_id: str | None
    device_id: str


def _parse_bearer_token(authorization: str | None) -> str:
    if not authorization:
        raise AppError(code='UNAUTHORIZED', message='Authentication is required', status_code=401)

    scheme, _, token = authorization.partition(' ')
    if scheme.lower() != 'bearer' or not token:
        raise AppError(code='UNAUTHORIZED', message='Invalid authorization header', status_code=401)
    return token


def get_current_user(authorization: Annotated[str | None, Header()] = None) -> AuthContext:
    token = _parse_bearer_token(authorization)
    settings = get_settings()

    try:
        payload = jwt.decode(token, settings.jwt_secret, algorithms=[settings.jwt_algorithm])
    except jwt.ExpiredSignatureError as exc:
        raise token_expired() from exc
    except jwt.PyJWTError as exc:
        raise token_invalid() from exc

    user_id = payload.get('sub')
    session_id = payload.get('sid')
    token_type = payload.get('type')
    if not user_id or token_type != 'access' or not session_id:
        raise token_invalid()

    return AuthContext(user_id=str(user_id), session_id=str(session_id))


def get_current_session(current_user: Annotated[AuthContext, Depends(get_current_user)]) -> AuthContext:
    return current_user


def get_current_device(
    current_user: Annotated[AuthContext, Depends(get_current_user)],
    x_device_id: Annotated[str | None, Header()] = None,
) -> DeviceContext:
    if not x_device_id:
        raise AppError(code='INVALID_DEVICE', message='X-Device-Id header is required', status_code=400)
    return DeviceContext(
        user_id=current_user.user_id,
        session_id=current_user.session_id,
        device_id=x_device_id,
    )
