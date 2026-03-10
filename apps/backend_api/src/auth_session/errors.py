from core.errors import AppError


class AuthSessionError(AppError):
    pass


def email_already_exists() -> AuthSessionError:
    return AuthSessionError('EMAIL_ALREADY_EXISTS', 'Email is already registered', 409)


def invalid_credentials() -> AuthSessionError:
    return AuthSessionError('INVALID_CREDENTIALS', 'Invalid email or password', 401)


def session_not_found() -> AuthSessionError:
    return AuthSessionError('SESSION_NOT_FOUND', 'Session was not found', 404)


def session_revoked() -> AuthSessionError:
    return AuthSessionError('SESSION_REVOKED', 'Session has already been revoked', 401)


def token_expired() -> AuthSessionError:
    return AuthSessionError('TOKEN_EXPIRED', 'Token has expired', 401)


def token_invalid() -> AuthSessionError:
    return AuthSessionError('TOKEN_INVALID', 'Token is invalid', 401)


def user_disabled() -> AuthSessionError:
    return AuthSessionError('USER_DISABLED', 'User account is disabled', 403)
