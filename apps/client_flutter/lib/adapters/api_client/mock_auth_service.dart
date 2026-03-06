import 'package:scribble/usecases/auth_usecases/auth_service.dart';
import 'package:scribble/usecases/auth_usecases/auth_session.dart';

class MockAuthService implements AuthService {
  @override
  Future<AuthSession> signIn({
    required String email,
    required String password,
  }) async {
    if (email.trim() == 'test@scribble.app' && password == '1234') {
      return AuthSession(
        accessToken: 'mock_access_token',
        refreshToken: 'mock_refresh_token',
        userId: 'mock-user-1',
        expiresAt: DateTime.now().add(const Duration(hours: 12)),
      );
    }
    throw StateError('AUTH_INVALID_CREDENTIALS');
  }

  @override
  Future<AuthSession> refresh({required String refreshToken}) async {
    if (refreshToken != 'mock_refresh_token') {
      throw StateError('AUTH_REFRESH_FAILED');
    }
    return AuthSession(
      accessToken: 'mock_access_token_refreshed',
      refreshToken: 'mock_refresh_token',
      userId: 'mock-user-1',
      expiresAt: DateTime.now().add(const Duration(hours: 12)),
    );
  }

  @override
  Future<void> signOut({required String accessToken}) async {}
}
