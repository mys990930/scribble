import 'package:drift/drift.dart';
import 'drift_database.dart';

part 'memo_dao.g.dart';

@DriftAccessor(tables: [Memos])
class MemoDao extends DatabaseAccessor<AppDatabase> with _$MemoDaoMixin {
  MemoDao(super.db);

  Future<List<Memo>> listActive() {
    return (select(memos)
          ..where((t) => t.isResolved.equals(false))
          ..orderBy([
            (t) => OrderingTerm.desc(t.urgentOrder),
            (t) => OrderingTerm.desc(t.createdAt),
          ]))
        .get();
  }

  Future<List<Memo>> listResolved() {
    return (select(memos)
          ..where((t) => t.isResolved.equals(true))
          ..orderBy([
            (t) => OrderingTerm.desc(t.updatedAt),
            (t) => OrderingTerm.desc(t.createdAt),
          ]))
        .get();
  }

  Future<int?> getMaxUrgentOrder() async {
    final q = selectOnly(memos)..addColumns([memos.urgentOrder.max()]);
    final row = await q.getSingleOrNull();
    return row?.read(memos.urgentOrder.max());
  }

  Future<int?> getMinUrgentOrder() async {
    final q = selectOnly(memos)..addColumns([memos.urgentOrder.min()]);
    final row = await q.getSingleOrNull();
    return row?.read(memos.urgentOrder.min());
  }

  Future<void> upsertMemo(MemosCompanion comp) async {
    await into(memos).insertOnConflictUpdate(comp);
  }

  Future<void> deleteMemo(String id) async {
    await (delete(memos)..where((t) => t.id.equals(id))).go();
  }
}
