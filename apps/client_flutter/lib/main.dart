import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_shell/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  String? initialRoute;
  if (!kIsWeb) {
    try {
      const channel = MethodChannel('scribble/widget');
      initialRoute = await channel.invokeMethod<String>('consumeLaunchRoute');
    } catch (_) {}
  }

  runApp(ProviderScope(child: MyApp(initialRoute: initialRoute)));
}
