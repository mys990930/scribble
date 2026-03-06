import 'package:scribble/usecases/auth_usecases/auth_session.dart';
import 'package:scribble/usecases/auth_usecases/auth_session_store.dart';

class LocalStorageAuthSessionStore implements AuthSessionStore {
  static AuthSession? _cached;

  @override
  Future<void> save(AuthSession session) async {
    _cached = session;
  }

  @override
  Future<AuthSession?> read() async {
    return _cached;
  }

  @override
  Future<void> clear() async {
    _cached = null;
  }
}
