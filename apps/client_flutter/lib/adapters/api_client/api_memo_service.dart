import 'package:scribble/domain/memo_domain/memo.dart';
import 'package:scribble/usecases/memo_usecases/memo_service.dart';

/// 웹 플랫폼용 MemoService 구현체.
/// 모든 데이터를 서버 API에서 직접 가져온다.
///
/// TODO: 백엔드 API 완성 후 HTTP 호출 구현.
class ApiMemoService implements MemoService {
  ApiMemoService();

  @override
  Future<List<Memo>> listActiveMemos() async {
    // TODO: GET /api/memos?resolved=false
    return [];
  }

  @override
  Future<List<Memo>> listResolvedMemos() async {
    // TODO: GET /api/memos?resolved=true
    return [];
  }

  @override
  Future<void> addMemo(
    String content, {
    DateTime? dueAt,
    bool alarmEnabled = false,
  }) async {
    // TODO: POST /api/memos
  }

  @override
  Future<void> updateMemo(Memo memo) async {
    // TODO: PUT /api/memos/:id
  }

  @override
  Future<void> toggleResolved(String memoId, bool resolved) async {
    // TODO: PATCH /api/memos/:id/resolve
  }

  @override
  Future<void> deleteMemo(String memoId) async {
    // TODO: DELETE /api/memos/:id
  }

  @override
  Future<void> reorderActiveMemos(List<String> idsInUiOrder) async {
    // TODO: PUT /api/memos/reorder
  }
}
