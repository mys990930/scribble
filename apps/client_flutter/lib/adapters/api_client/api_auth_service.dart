import 'package:scribble/usecases/auth_usecases/auth_service.dart';
import 'package:scribble/usecases/auth_usecases/auth_session.dart';

class ApiAuthService implements AuthService {
  @override
  Future<AuthSession> signIn({
    required String email,
    required String password,
  }) async {
    throw UnimplementedError('TODO: Implement auth-session signIn API');
  }

  @override
  Future<AuthSession> refresh({required String refreshToken}) async {
    throw UnimplementedError('TODO: Implement auth-session refresh API');
  }

  @override
  Future<void> signOut({required String accessToken}) async {
    throw UnimplementedError('TODO: Implement auth-session signOut API');
  }
}
