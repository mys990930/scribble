from functools import lru_cache

from pydantic import Field
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file='.env', env_file_encoding='utf-8', extra='ignore')

    app_env: str = Field(default='development', alias='APP_ENV')
    app_host: str = Field(default='0.0.0.0', alias='APP_HOST')
    app_port: int = Field(default=8000, alias='APP_PORT')

    database_url: str = Field(
        default='postgresql+asyncpg://postgres:postgres@localhost:5432/scribble',
        alias='DATABASE_URL',
    )

    jwt_secret: str = Field(default='change-me', alias='JWT_SECRET')
    jwt_algorithm: str = Field(default='HS256', alias='JWT_ALGORITHM')
    access_token_ttl_minutes: int = Field(default=15, alias='ACCESS_TOKEN_TTL_MINUTES')
    refresh_token_ttl_days: int = Field(default=30, alias='REFRESH_TOKEN_TTL_DAYS')

    device_limit_per_user: int = Field(default=5, alias='DEVICE_LIMIT_PER_USER')
    sync_cursor_ttl_days: int = Field(default=30, alias='SYNC_CURSOR_TTL_DAYS')


@lru_cache(maxsize=1)
def get_settings() -> Settings:
    return Settings()
