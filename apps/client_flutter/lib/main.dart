import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_shell/app.dart';

const _widgetChannel = MethodChannel('scribble/widget');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String? initialRoute;
  try {
    initialRoute = await _widgetChannel.invokeMethod<String>('consumeLaunchRoute');
  } catch (_) {}
  runApp(ProviderScope(child: MyApp(initialRoute: initialRoute)));
}
