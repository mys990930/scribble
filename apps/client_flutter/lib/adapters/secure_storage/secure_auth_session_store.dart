import 'package:scribble/usecases/auth_usecases/auth_session.dart';
import 'package:scribble/usecases/auth_usecases/auth_session_store.dart';

class SecureAuthSessionStore implements AuthSessionStore {
  @override
  Future<void> save(AuthSession session) async {
    // TODO: flutter_secure_storage 연동
  }

  @override
  Future<AuthSession?> read() async {
    // TODO: flutter_secure_storage 연동
    return null;
  }

  @override
  Future<void> clear() async {
    // TODO: flutter_secure_storage 연동
  }
}
