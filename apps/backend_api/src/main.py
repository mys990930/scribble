from fastapi import FastAPI

from auth_session import models as auth_models  # noqa: F401
from auth_session.router import router as auth_router
from core.errors import register_exception_handlers
from core.middleware import register_middleware
from device_registry import models as device_models  # noqa: F401
from device_registry.router import router as device_router
from sync_api import models as sync_models  # noqa: F401
from sync_api.router import router as sync_router


def create_app() -> FastAPI:
    app = FastAPI(title='Scribble Backend API', version='0.1.0')

    register_middleware(app)
    register_exception_handlers(app)

    @app.get('/healthz', tags=['system'])
    async def healthz() -> dict[str, str]:
        return {'status': 'ok'}

    app.include_router(auth_router)
    app.include_router(device_router)
    app.include_router(sync_router)
    return app


app = create_app()
