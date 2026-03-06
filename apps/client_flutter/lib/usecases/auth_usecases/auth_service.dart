import 'auth_session.dart';

abstract class AuthService {
  Future<AuthSession> signIn({required String email, required String password});

  Future<AuthSession> refresh({required String refreshToken});

  Future<void> signOut({required String accessToken});
}
