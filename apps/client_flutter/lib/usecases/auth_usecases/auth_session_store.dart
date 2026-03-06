import 'auth_session.dart';

abstract class AuthSessionStore {
  Future<void> save(AuthSession session);
  Future<AuthSession?> read();
  Future<void> clear();
}
