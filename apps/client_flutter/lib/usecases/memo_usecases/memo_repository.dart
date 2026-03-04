import 'package:scribble/domain/memo_domain/memo.dart';

/// Memo 저장소 인터페이스. storage-sqlite에서 구현한다.
abstract class MemoRepository {
  Future<List<Memo>> listActive();
  Future<List<Memo>> listResolved();
  Future<Memo?> getById(String id);
  Future<void> upsert(Memo memo);
  Future<void> delete(String id);
  Future<int?> getMaxUrgentOrder();
  Future<int?> getMinUrgentOrder();
}
