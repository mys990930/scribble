import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scribble/app_shell/di/di.dart';
import 'package:scribble/domain/memo_domain/memo.dart';

// memoServiceProvider는 di.dart에서 플랫폼별로 제공됨.
// 여기서 re-export하여 UI 코드가 기존처럼 사용 가능.
export 'package:scribble/app_shell/di/di.dart' show memoServiceProvider;

final activeMemosProvider =
    AsyncNotifierProvider<ActiveMemosNotifier, List<Memo>>(
      ActiveMemosNotifier.new,
    );

class ActiveMemosNotifier extends AsyncNotifier<List<Memo>> {
  Future<List<Memo>> _fetch() async {
    final service = ref.read(memoServiceProvider);
    return service.listActiveMemos();
  }

  @override
  List<Memo> build() {
    unawaited(refresh());
    return state.valueOrNull ?? const [];
  }

  Future<void> refresh() async {
    final previous = state.valueOrNull ?? const <Memo>[];
    state = AsyncData(previous);
    try {
      final latest = await _fetch();
      state = AsyncData(latest);
    } catch (_) {
      state = AsyncData(previous);
    }
  }
}

final resolvedMemosProvider = FutureProvider<List<Memo>>((ref) async {
  final service = ref.watch(memoServiceProvider);
  return service.listResolvedMemos();
});
