import 'package:flutter_test/flutter_test.dart';
import 'package:scribble/usecases/auth_usecases/auth_service.dart';
import 'package:scribble/usecases/auth_usecases/auth_session.dart';
import 'package:scribble/usecases/auth_usecases/auth_session_store.dart';
import 'package:scribble/usecases/auth_usecases/auth_state.dart';
import 'package:scribble/usecases/auth_usecases/auth_usecase_impl.dart';

class FakeAuthService implements AuthService {
  @override
  Future<AuthSession> refresh({required String refreshToken}) async {
    throw UnimplementedError();
  }

  @override
  Future<AuthSession> signIn({
    required String email,
    required String password,
  }) async {
    return AuthSession(
      accessToken: 'access',
      refreshToken: 'refresh',
      userId: 'user-1',
      expiresAt: DateTime.parse('2026-03-10T10:00:00Z'),
    );
  }

  @override
  Future<void> signOut({required String accessToken}) async {}
}

class InMemoryAuthSessionStore implements AuthSessionStore {
  AuthSession? value;

  @override
  Future<void> clear() async {
    value = null;
  }

  @override
  Future<AuthSession?> read() async {
    return value;
  }

  @override
  Future<void> save(AuthSession session) async {
    value = session;
  }
}

void main() {
  group('AuthUsecaseImpl.signIn', () {
    test('afterSignIn 성공 시 authenticated를 반환한다', () async {
      final store = InMemoryAuthSessionStore();
      var called = false;
      final usecase = AuthUsecaseImpl(
        authService: FakeAuthService(),
        sessionStore: store,
        afterSignIn: (session) async {
          called = true;
        },
      );

      final state = await usecase.signIn(email: 'a', password: 'b');

      expect(state, AuthState.authenticated);
      expect(called, isTrue);
      expect(store.value, isNotNull);
    });

    test('afterSignIn 실패 시 저장 세션을 비우고 에러를 다시 던진다', () async {
      final store = InMemoryAuthSessionStore();
      final usecase = AuthUsecaseImpl(
        authService: FakeAuthService(),
        sessionStore: store,
        afterSignIn: (session) async {
          throw StateError('DEVICE_BOOTSTRAP_FAILED');
        },
      );

      expect(
        () => usecase.signIn(email: 'a', password: 'b'),
        throwsA(
          isA<StateError>().having(
            (e) => e.message,
            'message',
            'DEVICE_BOOTSTRAP_FAILED',
          ),
        ),
      );
      expect(store.value, isNull);
    });
  });
}
