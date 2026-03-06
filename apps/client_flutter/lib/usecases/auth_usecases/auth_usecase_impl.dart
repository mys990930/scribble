import 'auth_service.dart';
import 'auth_session_store.dart';
import 'auth_state.dart';
import 'auth_usecase.dart';

class AuthUsecaseImpl implements AuthUsecase {
  final AuthService authService;
  final AuthSessionStore sessionStore;

  AuthUsecaseImpl({required this.authService, required this.sessionStore});

  @override
  Future<AuthState> restoreSession() async {
    final session = await sessionStore.read();
    if (session == null) return AuthState.unauthenticated;

    if (!session.isExpired) return AuthState.authenticated;

    try {
      final refreshed = await authService.refresh(
        refreshToken: session.refreshToken,
      );
      await sessionStore.save(refreshed);
      return AuthState.authenticated;
    } catch (_) {
      await sessionStore.clear();
      return AuthState.unauthenticated;
    }
  }

  @override
  Future<AuthState> signIn({
    required String email,
    required String password,
  }) async {
    final session = await authService.signIn(email: email, password: password);
    await sessionStore.save(session);
    return AuthState.authenticated;
  }

  @override
  Future<void> signOut() async {
    final current = await sessionStore.read();
    try {
      if (current != null) {
        await authService.signOut(accessToken: current.accessToken);
      }
    } catch (_) {
      // best effort
    }
    await sessionStore.clear();
  }
}
