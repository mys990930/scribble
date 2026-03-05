import 'package:scribble/domain/memo_domain/memo.dart';
import 'package:scribble/domain/memo_domain/memo_rules.dart';
import 'package:scribble/usecases/memo_usecases/memo_repository.dart';
import 'package:scribble/usecases/memo_usecases/memo_service.dart';

typedef MemoIdGenerator = String Function();
typedef MemoNow = DateTime Function();

class MemoServiceImpl implements MemoService {
  final MemoRepository repository;
  final MemoIdGenerator idGenerator;
  final MemoNow now;

  MemoServiceImpl({
    required this.repository,
    required this.idGenerator,
    required this.now,
  });

  @override
  Future<List<Memo>> listActiveMemos() => repository.listActive();

  @override
  Future<List<Memo>> listResolvedMemos() => repository.listResolved();

  bool _isHigherPriority(DateTime? a, DateTime? b) {
    if (a != null && b == null) return true;
    if (a == null) return false;
    return a.isBefore(b!);
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
    final trimmed = content.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError('MEMO_EMPTY_CONTENT');
    }

    final currentNow = now();
    final active = await repository.listActive();
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
        for (int i = index; i < active.length; i++) {
          final memo = active[i];
          await repository.upsert(
            memo.copyWith(
              urgentOrder: memo.urgentOrder - 1,
              updatedAt: currentNow,
            ),
          );
        }
        newPriority = prev - 1;
      }
    }

    await repository.upsert(
      Memo(
        id: idGenerator(),
        content: trimmed,
        createdAt: currentNow,
        updatedAt: currentNow,
        isResolved: false,
        urgentOrder: newPriority,
        dueAt: dueAt,
        alarmEnabled: alarmEnabled,
        alarmNotifiedAt: null,
      ),
    );
  }

  @override
  Future<void> updateMemo(Memo memo) async {
    final trimmed = memo.content.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError('MEMO_EMPTY_CONTENT');
    }

    await repository.upsert(memo.copyWith(content: trimmed, updatedAt: now()));
  }

  @override
  Future<void> toggleResolved(String memoId, bool resolved) async {
    final target = await repository.getById(memoId);
    if (target == null) return;

    await repository.upsert(
      target.copyWith(
        isResolved: resolved,
        updatedAt: now(),
        clearAlarmNotifiedAt: !resolved,
      ),
    );
  }

  @override
  Future<void> deleteMemo(String memoId) => repository.delete(memoId);

  @override
  Future<void> reorderActiveMemos(List<String> idsInUiOrder) async {
    final active = await repository.listActive();
    final total = idsInUiOrder.length;
    final start = (total - 1) ~/ 2;
    final orderById = {
      for (int i = 0; i < total; i++) idsInUiOrder[i]: start - i,
    };

    final currentNow = now();
    for (final memo in active) {
      final nextOrder = orderById[memo.id];
      if (nextOrder == null) continue;
      if (memo.urgentOrder == nextOrder) continue;
      await repository.upsert(
        memo.copyWith(urgentOrder: nextOrder, updatedAt: currentNow),
      );
    }
  }

  @override
  Future<List<Memo>> checkAlarms(DateTime now) async {
    final active = await repository.listActive();
    return active.where((memo) => shouldNotifyAlarm(memo, now)).toList();
  }
}
