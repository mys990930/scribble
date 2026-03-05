import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scribble/adapters/storage_sqlite/drift_database.dart';
import 'package:scribble/adapters/storage_sqlite/drift_memo_repo.dart';
import 'package:scribble/usecases/memo_usecases/memo_service.dart';

final _databaseProvider = Provider<AppDatabase>((ref) => AppDatabase());

MemoService createMemoService(Ref ref) {
  final db = ref.watch(_databaseProvider);
  return DriftMemoService(db);
}
