import 'package:drift/drift.dart' show Value;
import 'package:uuid/uuid.dart';

import '../../domain/models/memo.dart' as d;
import '../db/daos/memo_dao.dart';
import '../db/drift_database.dart';

const _uuid = Uuid();

abstract class MemoRepo {
  Future<List<d.Memo>> listActiveMemos();
  Future<List<d.Memo>> listResolvedMemos();
  Future<void> addMemo(
    String content, {
    DateTime? dueAt,
    bool alarmEnabled = false,
  });
  Future<void> updateMemo(d.Memo memo);
  Future<void> toggleResolved(String memoId, bool resolved);
  Future<void> deleteMemo(String memoId);
  Future<void> reorderActiveMemos(List<String> idsInUiOrder);
}

class DriftMemoRepo implements MemoRepo {
  final AppDatabase db;
  final MemoDao dao;

  DriftMemoRepo(this.db) : dao = MemoDao(db);

  @override
  Future<List<d.Memo>> listActiveMemos() async {
    final rows = await dao.listActive();
    return rows.map(_toDomain).toList();
  }

  @override
  Future<List<d.Memo>> listResolvedMemos() async {
    final rows = await dao.listResolved();
    return rows.map(_toDomain).toList();
  }

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

  bool _isHigherPriority(DateTime? a, DateTime? b) {
    if (a != null && b == null) return true;
    if (a == null && b != null) return false;
    if (a == null && b == null) return false;
    return a!.isBefore(b!);
  }

  int _insertIndex(List<Memo> ordered, DateTime? dueAt) {
    for (int i = 0; i < ordered.length; i++) {
      if (_isHigherPriority(dueAt, ordered[i].dueAt)) return i;
    }
    return ordered.length;
  }

  @override
  Future<void> addMemo(
    String content, {
    DateTime? dueAt,
    bool alarmEnabled = false,
  }) async {
    final now = DateTime.now();
    final id = _uuid.v4();

    await db.transaction(() async {
      final active = await dao.listActive(); // priority DESC
      final index = _insertIndex(active, dueAt);

      int newPriority;
      if (active.isEmpty) {
        newPriority = 0;
      } else if (index == 0) {
        newPriority = active.first.urgentOrder + 1;
      } else if (index == active.length) {
        newPriority = active.last.urgentOrder - 1;
      } else {
        final prev = active[index - 1].urgentOrder;
        final next = active[index].urgentOrder;
        if (prev - next >= 2) {
          newPriority = (prev + next) ~/ 2;
        } else {
          // minimum changes: only shift lower-priority tail
          for (int i = index; i < active.length; i++) {
            final m = active[i];
            await dao.upsertMemo(
              MemosCompanion(
                id: Value(m.id),
                content: Value(m.content),
                createdAt: Value(m.createdAt),
                updatedAt: Value(now),
                isResolved: Value(m.isResolved),
                urgentOrder: Value(m.urgentOrder - 1),
                dueAt: Value(m.dueAt),
                alarmEnabled: Value(m.alarmEnabled),
                alarmNotifiedAt: Value(m.alarmNotifiedAt),
              ),
            );
          }
          newPriority = prev - 1;
        }
      }

      await dao.upsertMemo(
        MemosCompanion(
          id: Value(id),
          content: Value(content),
          createdAt: Value(now),
          updatedAt: Value(now),
          isResolved: const Value(false),
          urgentOrder: Value(newPriority),
          dueAt: Value(dueAt),
          alarmEnabled: Value(alarmEnabled),
          alarmNotifiedAt: const Value(null),
        ),
      );
    });
  }

  @override
  Future<void> updateMemo(d.Memo memo) async {
    await dao.upsertMemo(
      MemosCompanion(
        id: Value(memo.id),
        content: Value(memo.content),
        createdAt: Value(memo.createdAt),
        updatedAt: Value(DateTime.now()),
        isResolved: Value(memo.isResolved),
        urgentOrder: Value(memo.urgentOrder),
        dueAt: Value(memo.dueAt),
        alarmEnabled: Value(memo.alarmEnabled),
        alarmNotifiedAt: Value(memo.alarmNotifiedAt),
      ),
    );
  }

  @override
  Future<void> toggleResolved(String memoId, bool resolved) async {
    final target = await (db.select(
      db.memos,
    )..where((t) => t.id.equals(memoId))).getSingleOrNull();
    if (target == null) return;
    await dao.upsertMemo(
      MemosCompanion(
        id: Value(target.id),
        content: Value(target.content),
        createdAt: Value(target.createdAt),
        updatedAt: Value(DateTime.now()),
        isResolved: Value(resolved),
        urgentOrder: Value(target.urgentOrder),
        dueAt: Value(target.dueAt),
        alarmEnabled: Value(target.alarmEnabled),
        alarmNotifiedAt: Value(resolved ? target.alarmNotifiedAt : null),
      ),
    );
  }

  @override
  Future<void> deleteMemo(String memoId) => dao.deleteMemo(memoId);

  @override
  Future<void> reorderActiveMemos(List<String> idsInUiOrder) async {
    final total = idsInUiOrder.length;
    final now = DateTime.now();
    final start = (total - 1) ~/ 2;

    final map = {for (int i = 0; i < total; i++) idsInUiOrder[i]: start - i};

    final current = await db.select(db.memos).get();
    await db.transaction(() async {
      for (final m in current.where((e) => map.containsKey(e.id))) {
        await dao.upsertMemo(
          MemosCompanion(
            id: Value(m.id),
            content: Value(m.content),
            createdAt: Value(m.createdAt),
            updatedAt: Value(now),
            isResolved: Value(m.isResolved),
            urgentOrder: Value(map[m.id]!),
            dueAt: Value(m.dueAt),
            alarmEnabled: Value(m.alarmEnabled),
            alarmNotifiedAt: Value(m.alarmNotifiedAt),
          ),
        );
      }
    });
  }
}
