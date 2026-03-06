import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scribble/app_shell/di/di.dart';
import 'package:scribble/app_shell/routes.dart';
import 'package:scribble/usecases/auth_usecases/auth_state.dart';

class AuthGateScreen extends ConsumerStatefulWidget {
  const AuthGateScreen({super.key});

  @override
  ConsumerState<AuthGateScreen> createState() => _AuthGateScreenState();
}

class _AuthGateScreenState extends ConsumerState<AuthGateScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final usecase = ref.read(authUsecaseProvider);
    final state = await usecase.restoreSession();

    if (!mounted) return;

    if (state == AuthState.authenticated) {
      Navigator.of(context).pushReplacementNamed(Routes.main);
    } else {
      Navigator.of(context).pushReplacementNamed(Routes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Scribble'),
          ],
        ),
      ),
    );
  }
}
