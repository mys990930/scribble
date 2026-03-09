from core.errors import AppError


class AuthSessionError(AppError):
    pass


def email_already_exists() -> AuthSessionError:
    return AuthSessionError('EMAIL_ALREADY_EXISTS', 'Email is already registered', 409)


def invalid_credentials() -> AuthSessionError:
    return AuthSessionError('INVALID_CREDENTIALS', 'Invalid email or password', 401)
