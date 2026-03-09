import uuid
from collections.abc import Awaitable, Callable

from fastapi import FastAPI, Request, Response
from fastapi.middleware.cors import CORSMiddleware

RequestHandler = Callable[[Request], Awaitable[Response]]


async def request_id_middleware(request: Request, call_next: RequestHandler) -> Response:
    request_id = request.headers.get('X-Request-Id', str(uuid.uuid4()))
    request.state.request_id = request_id

    response = await call_next(request)
    response.headers['X-Request-Id'] = request_id
    return response


def register_middleware(app: FastAPI) -> None:
    app.middleware('http')(request_id_middleware)
    app.add_middleware(
        CORSMiddleware,
        allow_origins=['*'],
        allow_credentials=True,
        allow_methods=['*'],
        allow_headers=['*'],
    )
