import 'package:scribble/adapters/secure_storage/secure_value_store.dart';
import 'package:scribble/usecases/auth_usecases/auth_session.dart';
import 'package:scribble/usecases/auth_usecases/auth_session_store.dart';

class SecureAuthSessionStore implements AuthSessionStore {
  static const _accessTokenKey = 'auth.access_token';
  static const _refreshTokenKey = 'auth.refresh_token';
  static const _userIdKey = 'auth.user_id';
  static const _expiresAtKey = 'auth.expires_at';

  final SecureValueStore _store;

  SecureAuthSessionStore({SecureValueStore? store})
    : _store = store ?? FlutterSecureValueStore();

  @override
  Future<void> save(AuthSession session) async {
    await _store.write(key: _accessTokenKey, value: session.accessToken);
    await _store.write(key: _refreshTokenKey, value: session.refreshToken);
    await _store.write(key: _userIdKey, value: session.userId);
    await _store.write(
      key: _expiresAtKey,
      value: session.expiresAt.toUtc().toIso8601String(),
    );
  }

  @override
  Future<AuthSession?> read() async {
    final accessToken = await _store.read(key: _accessTokenKey);
    final refreshToken = await _store.read(key: _refreshTokenKey);
    final userId = await _store.read(key: _userIdKey);
    final expiresAtRaw = await _store.read(key: _expiresAtKey);

    if (accessToken == null ||
        refreshToken == null ||
        userId == null ||
        expiresAtRaw == null) {
      return null;
    }

    final expiresAt = DateTime.tryParse(expiresAtRaw);
    if (expiresAt == null) {
      return null;
    }

    return AuthSession(
      accessToken: accessToken,
      refreshToken: refreshToken,
      userId: userId,
      expiresAt: expiresAt.toLocal(),
    );
  }

  @override
  Future<void> clear() async {
    await _store.delete(key: _accessTokenKey);
    await _store.delete(key: _refreshTokenKey);
    await _store.delete(key: _userIdKey);
    await _store.delete(key: _expiresAtKey);
  }
}
