from typing import Annotated

from fastapi import APIRouter, Depends, Query
from sqlalchemy.ext.asyncio import AsyncSession

from core.auth_deps import DeviceContext, get_current_device
from core.database import get_db_session
from device_registry.repository import DeviceRegistryRepository
from device_registry.service import DeviceRegistryService
from sync_api.repository import SyncApiRepository
from sync_api.schemas import PullResponse, PushRequest, PushResponse
from sync_api.service import SyncApiService

router = APIRouter(prefix='/sync', tags=['sync-api'])


def get_sync_api_service(
    session: Annotated[AsyncSession, Depends(get_db_session)],
) -> SyncApiService:
    sync_repository = SyncApiRepository(session)
    device_service = DeviceRegistryService(DeviceRegistryRepository(session))
    return SyncApiService(repository=sync_repository, device_service=device_service)


@router.post('/push', response_model=PushResponse)
async def push(
    payload: PushRequest,
    device: Annotated[DeviceContext, Depends(get_current_device)],
    service: Annotated[SyncApiService, Depends(get_sync_api_service)],
) -> PushResponse:
    return await service.push(device.user_id, device.device_id, payload)


@router.get('/pull', response_model=PullResponse)
async def pull(
    device: Annotated[DeviceContext, Depends(get_current_device)],
    service: Annotated[SyncApiService, Depends(get_sync_api_service)],
    cursor: Annotated[str | None, Query()] = None,
) -> PullResponse:
    return await service.pull(device.user_id, device.device_id, cursor)
