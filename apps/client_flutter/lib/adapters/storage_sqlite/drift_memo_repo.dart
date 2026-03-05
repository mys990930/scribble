import 'package:drift/drift.dart' show Value;
import 'package:scribble/domain/memo_domain/memo.dart' as d;
import 'package:scribble/usecases/memo_usecases/memo_repository.dart';

import 'drift_database.dart';
import 'memo_dao.dart';

class DriftMemoRepository implements MemoRepository {
  final AppDatabase db;
  final MemoDao dao;

  DriftMemoRepository(this.db) : dao = MemoDao(db);

  d.Memo _toDomain(Memo m) => d.Memo(
    id: m.id,
    content: m.content,
    createdAt: m.createdAt,
    updatedAt: m.updatedAt,
    isResolved: m.isResolved,
    urgentOrder: m.urgentOrder,
    dueAt: m.dueAt,
    alarmEnabled: m.alarmEnabled,
    alarmNotifiedAt: m.alarmNotifiedAt,
  );

  MemosCompanion _toCompanion(d.Memo memo) => MemosCompanion(
    id: Value(memo.id),
    content: Value(memo.content),
    createdAt: Value(memo.createdAt),
    updatedAt: Value(memo.updatedAt),
    isResolved: Value(memo.isResolved),
    urgentOrder: Value(memo.urgentOrder),
    dueAt: Value(memo.dueAt),
    alarmEnabled: Value(memo.alarmEnabled),
    alarmNotifiedAt: Value(memo.alarmNotifiedAt),
  );

  @override
  Future<List<d.Memo>> listActive() async {
    final rows = await dao.listActive();
    return rows.map(_toDomain).toList();
  }

  @override
  Future<List<d.Memo>> listResolved() async {
    final rows = await dao.listResolved();
    return rows.map(_toDomain).toList();
  }

  @override
  Future<d.Memo?> getById(String id) async {
    final row = await (db.select(
      db.memos,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    if (row == null) return null;
    return _toDomain(row);
  }

  @override
  Future<void> upsert(d.Memo memo) => dao.upsertMemo(_toCompanion(memo));

  @override
  Future<void> delete(String id) => dao.deleteMemo(id);

  @override
  Future<int?> getMaxUrgentOrder() => dao.getMaxUrgentOrder();

  @override
  Future<int?> getMinUrgentOrder() => dao.getMinUrgentOrder();
}
