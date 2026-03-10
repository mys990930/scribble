from typing import Annotated

from fastapi import APIRouter, Depends, Header, Request, status
from sqlalchemy.ext.asyncio import AsyncSession

from core.auth_deps import AuthContext, get_current_user
from core.database import get_db_session
from device_registry.repository import DeviceRegistryRepository
from device_registry.schemas import (
    DeactivateDeviceResponse,
    DeviceListResponse,
    DeviceResponse,
    RegisterDeviceRequest,
)
from device_registry.service import DeviceRegistryService

router = APIRouter(prefix='/devices', tags=['device-registry'])


def get_device_registry_service(
    session: Annotated[AsyncSession, Depends(get_db_session)],
) -> DeviceRegistryService:
    repository = DeviceRegistryRepository(session)
    return DeviceRegistryService(repository=repository)


@router.post('', response_model=DeviceResponse, status_code=status.HTTP_201_CREATED)
async def register_device(
    payload: RegisterDeviceRequest,
    request: Request,
    current_user: Annotated[AuthContext, Depends(get_current_user)],
    service: Annotated[DeviceRegistryService, Depends(get_device_registry_service)],
    user_agent: Annotated[str | None, Header()] = None,
) -> DeviceResponse:
    client_host = request.client.host if request.client else None
    return await service.register_device(
        current_user.user_id,
        payload,
        last_ip=client_host,
        last_user_agent=user_agent,
    )


@router.get('', response_model=DeviceListResponse)
async def list_devices(
    current_user: Annotated[AuthContext, Depends(get_current_user)],
    service: Annotated[DeviceRegistryService, Depends(get_device_registry_service)],
) -> DeviceListResponse:
    return await service.list_devices(current_user.user_id)


@router.delete('/{device_id}', response_model=DeactivateDeviceResponse)
async def deactivate_device(
    device_id: str,
    current_user: Annotated[AuthContext, Depends(get_current_user)],
    service: Annotated[DeviceRegistryService, Depends(get_device_registry_service)],
) -> DeactivateDeviceResponse:
    return await service.deactivate_device(current_user.user_id, device_id)
