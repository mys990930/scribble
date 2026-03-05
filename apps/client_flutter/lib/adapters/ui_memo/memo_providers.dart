import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scribble/domain/memo_domain/memo.dart';
import 'package:scribble/app_shell/di/di.dart';

// memoServiceProvider는 di.dart에서 플랫폼별로 제공됨.
// 여기서 re-export하여 UI 코드가 기존처럼 사용 가능.
export 'package:scribble/app_shell/di/di.dart' show memoServiceProvider;

final activeMemosProvider = FutureProvider<List<Memo>>((ref) async {
  final service = ref.watch(memoServiceProvider);
  return service.listActiveMemos();
});

final resolvedMemosProvider = FutureProvider<List<Memo>>((ref) async {
  final service = ref.watch(memoServiceProvider);
  return service.listResolvedMemos();
});
