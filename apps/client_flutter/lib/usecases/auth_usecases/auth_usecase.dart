import 'auth_state.dart';

abstract class AuthUsecase {
  Future<AuthState> restoreSession();
  Future<AuthState> signIn({required String email, required String password});
  Future<void> signOut();
}
