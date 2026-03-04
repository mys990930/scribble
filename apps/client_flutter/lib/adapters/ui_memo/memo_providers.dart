import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scribble/adapters/storage_sqlite/drift_database.dart' as db;
import 'package:scribble/adapters/storage_sqlite/drift_memo_repo.dart';
import 'package:scribble/domain/memo_domain/memo.dart';
import 'package:scribble/usecases/memo_usecases/memo_service.dart';

final databaseProvider = Provider<db.AppDatabase>((ref) => db.AppDatabase());

final memoServiceProvider = Provider<MemoService>((ref) {
  final database = ref.watch(databaseProvider);
  return DriftMemoService(database);
});

final activeMemosProvider = FutureProvider<List<Memo>>((ref) async {
  final service = ref.watch(memoServiceProvider);
  return service.listActiveMemos();
});

final resolvedMemosProvider = FutureProvider<List<Memo>>((ref) async {
  final service = ref.watch(memoServiceProvider);
  return service.listResolvedMemos();
});
