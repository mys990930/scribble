import 'package:scribble/domain/memo_domain/memo.dart';
import 'package:scribble/usecases/memo_usecases/memo_repository.dart';

/// 웹 플랫폼용 MemoRepository 구현체.
/// 모든 데이터를 서버 API에서 직접 가져온다.
/// TODO: 백엔드 API 완성 후 HTTP 호출 구현.
class ApiMemoRepository implements MemoRepository {
  ApiMemoRepository();

  @override
  Future<List<Memo>> listActive() async {
    // TODO: GET /api/memos?resolved=false
    return [];
  }

  @override
  Future<List<Memo>> listResolved() async {
    // TODO: GET /api/memos?resolved=true
    return [];
  }

  @override
  Future<Memo?> getById(String id) async {
    // TODO: GET /api/memos/:id
    return null;
  }

  @override
  Future<void> upsert(Memo memo) async {
    // TODO: POST/PUT /api/memos
  }

  @override
  Future<void> delete(String id) async {
    // TODO: DELETE /api/memos/:id
  }

  @override
  Future<int?> getMaxUrgentOrder() async {
    // TODO: 서버 정렬 정책 확정 시 구현
    return null;
  }

  @override
  Future<int?> getMinUrgentOrder() async {
    // TODO: 서버 정렬 정책 확정 시 구현
    return null;
  }
}
