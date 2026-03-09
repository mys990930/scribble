from typing import Annotated

from fastapi import APIRouter, Depends, Response, status
from sqlalchemy.ext.asyncio import AsyncSession

from auth_session.repository import AuthSessionRepository
from auth_session.schemas import (
    CurrentUserResponse,
    LoginRequest,
    RefreshRequest,
    RegisterRequest,
    TokenPairResponse,
    UserResponse,
)
from auth_session.service import AuthSessionService
from core.auth_deps import AuthContext, get_current_session, get_current_user
from core.database import get_db_session

router = APIRouter(prefix='/auth', tags=['auth-session'])


def get_auth_session_service(
    session: Annotated[AsyncSession, Depends(get_db_session)],
) -> AuthSessionService:
    repository = AuthSessionRepository(session)
    return AuthSessionService(repository=repository)


@router.post('/register', response_model=UserResponse, status_code=status.HTTP_201_CREATED)
async def register(
    payload: RegisterRequest,
    service: Annotated[AuthSessionService, Depends(get_auth_session_service)],
) -> UserResponse:
    return await service.register(payload)


@router.post('/login', response_model=TokenPairResponse)
async def login(
    payload: LoginRequest,
    service: Annotated[AuthSessionService, Depends(get_auth_session_service)],
) -> TokenPairResponse:
    return await service.login(payload)


@router.post('/refresh', response_model=TokenPairResponse)
async def refresh(
    payload: RefreshRequest,
    service: Annotated[AuthSessionService, Depends(get_auth_session_service)],
) -> TokenPairResponse:
    return await service.refresh(payload)


@router.post('/logout', status_code=status.HTTP_204_NO_CONTENT)
async def logout(
    current_session: Annotated[AuthContext, Depends(get_current_session)],
    service: Annotated[AuthSessionService, Depends(get_auth_session_service)],
) -> Response:
    await service.logout(current_session.session_id)
    return Response(status_code=status.HTTP_204_NO_CONTENT)


@router.get('/me', response_model=CurrentUserResponse)
async def me(
    current_user: Annotated[AuthContext, Depends(get_current_user)],
    service: Annotated[AuthSessionService, Depends(get_auth_session_service)],
) -> CurrentUserResponse:
    return await service.get_current_user(current_user.user_id)
