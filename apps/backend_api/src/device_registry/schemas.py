from pydantic import BaseModel, ConfigDict, Field


class RegisterDeviceRequest(BaseModel):
    device_id: str = Field(min_length=1, max_length=128)
    platform: str = Field(min_length=1, max_length=20)
    name: str = Field(min_length=1, max_length=120)
    app_version: str | None = Field(default=None, max_length=40)


class DeviceResponse(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: str
    device_id: str
    platform: str
    name: str
    app_version: str | None = None
    is_active: bool = True


class DeviceListResponse(BaseModel):
    devices: list[DeviceResponse]


class DeactivateDeviceResponse(BaseModel):
    device_id: str
    deactivated: bool
