import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scribble/usecases/memo_usecases/memo_service.dart';

import 'di_stub.dart'
    if (dart.library.io) 'di_native.dart'
    if (dart.library.js_interop) 'di_web.dart' as platform;

/// 플랫폼별 MemoService provider.
/// - 네이티브: DriftMemoService (SQLite)
/// - 웹: ApiMemoService (HTTP)
final memoServiceProvider = Provider<MemoService>((ref) {
  return platform.createMemoService(ref);
});
