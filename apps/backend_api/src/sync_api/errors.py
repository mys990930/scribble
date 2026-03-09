from core.errors import AppError


class SyncApiError(AppError):
    pass


def invalid_device() -> SyncApiError:
    return SyncApiError('INVALID_DEVICE', 'Device is invalid for sync', 403)
