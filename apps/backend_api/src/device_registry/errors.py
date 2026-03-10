from core.errors import AppError


class DeviceRegistryError(AppError):
    pass


def device_already_registered() -> DeviceRegistryError:
    return DeviceRegistryError('DEVICE_ALREADY_REGISTERED', 'Device is already registered', 409)


def device_limit_exceeded() -> DeviceRegistryError:
    return DeviceRegistryError('DEVICE_LIMIT_EXCEEDED', 'Device limit exceeded', 409)


def device_not_found() -> DeviceRegistryError:
    return DeviceRegistryError('DEVICE_NOT_FOUND', 'Device was not found', 404)


def device_inactive() -> DeviceRegistryError:
    return DeviceRegistryError('DEVICE_INACTIVE', 'Device is inactive', 403)
