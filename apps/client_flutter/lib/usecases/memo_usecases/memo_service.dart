import 'package:scribble/domain/memo_domain/memo.dart';

/// Memo usecase 서비스 인터페이스.
/// UI에서 이 인터페이스를 통해 메모를 조작한다.
abstract class MemoService {
  Future<List<Memo>> listActiveMemos();
  Future<List<Memo>> listResolvedMemos();
  Future<void> addMemo(
    String content, {
    DateTime? dueAt,
    bool alarmEnabled = false,
  });
  Future<void> updateMemo(Memo memo);
  Future<void> toggleResolved(String memoId, bool resolved);
  Future<void> deleteMemo(String memoId);
  Future<void> reorderActiveMemos(List<String> idsInUiOrder);
  Future<List<Memo>> checkAlarms(DateTime now);
}
