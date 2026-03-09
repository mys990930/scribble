from core.errors import AppError


class DeviceRegistryError(AppError):
    pass


def device_not_found() -> DeviceRegistryError:
    return DeviceRegistryError('DEVICE_NOT_FOUND', 'Device was not found', 404)
