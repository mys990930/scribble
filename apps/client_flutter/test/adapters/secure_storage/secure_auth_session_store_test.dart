import 'package:flutter_test/flutter_test.dart';
import 'package:scribble/adapters/secure_storage/secure_auth_session_store.dart';
import 'package:scribble/adapters/secure_storage/secure_value_store.dart';
import 'package:scribble/usecases/auth_usecases/auth_session.dart';

class FakeSecureValueStore implements SecureValueStore {
  final Map<String, String> values = {};

  @override
  Future<void> delete({required String key}) async => values.remove(key);

  @override
  Future<String?> read({required String key}) async => values[key];

  @override
  Future<void> write({required String key, required String value}) async {
    values[key] = value;
  }
}

void main() {
  group('SecureAuthSessionStore', () {
    test('save 후 read 시 동일 세션을 반환한다', () async {
      final store = FakeSecureValueStore();
      final sessionStore = SecureAuthSessionStore(store: store);
      final session = AuthSession(
        accessToken: 'access',
        refreshToken: 'refresh',
        userId: 'user-1',
        expiresAt: DateTime.parse('2026-03-10T10:00:00Z'),
      );

      await sessionStore.save(session);

      final restored = await sessionStore.read();

      expect(restored, isNotNull);
      expect(restored!.accessToken, session.accessToken);
      expect(restored.refreshToken, session.refreshToken);
      expect(restored.userId, session.userId);
      expect(restored.expiresAt.toUtc(), session.expiresAt.toUtc());
    });

    test('clear 후 read 결과는 null이다', () async {
      final store = FakeSecureValueStore();
      final sessionStore = SecureAuthSessionStore(store: store);

      await sessionStore.save(
        AuthSession(
          accessToken: 'access',
          refreshToken: 'refresh',
          userId: 'user-1',
          expiresAt: DateTime.parse('2026-03-10T10:00:00Z'),
        ),
      );

      await sessionStore.clear();

      expect(await sessionStore.read(), isNull);
    });

    test('필드 일부 누락이면 null을 반환한다', () async {
      final store = FakeSecureValueStore()
        ..values['auth.access_token'] = 'access'
        ..values['auth.refresh_token'] = 'refresh';
      final sessionStore = SecureAuthSessionStore(store: store);

      expect(await sessionStore.read(), isNull);
    });

    test('잘못된 expires_at이면 null을 반환한다', () async {
      final store = FakeSecureValueStore()
        ..values['auth.access_token'] = 'access'
        ..values['auth.refresh_token'] = 'refresh'
        ..values['auth.user_id'] = 'user-1'
        ..values['auth.expires_at'] = 'not-a-date';
      final sessionStore = SecureAuthSessionStore(store: store);

      expect(await sessionStore.read(), isNull);
    });
  });
}
