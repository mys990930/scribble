import 'package:flutter_test/flutter_test.dart';
import 'package:scribble/domain/archive_domain/archive_entry.dart';
import 'package:scribble/usecases/archive_usecases/archive_repository.dart';
import 'package:scribble/usecases/archive_usecases/delete_archive_usecase.dart';

class _FakeArchiveRepository implements ArchiveRepository {
  String? deletedId;

  @override
  Future<void> delete(String id) async {
    deletedId = id;
  }

  @override
  Future<ArchiveEntry?> getById(String id) async => null;

  @override
  Future<List<ArchiveEntry>> listAll() async => [];

  @override
  Future<List<ArchiveEntry>> listByCategory(String category) async => [];

  @override
  Future<void> save(ArchiveEntry entry) async {}

  @override
  Future<List<String>> listRecentCategories() async => [];

  @override
  Future<List<ArchiveEntry>> search(String query, {String? category}) async => [];
}

void main() {
  test('DeleteArchiveUseCase는 delete를 위임 호출한다', () async {
    final repo = _FakeArchiveRepository();
    final usecase = DeleteArchiveUseCase(archiveRepository: repo);

    await usecase.execute('archive-1');

    expect(repo.deletedId, 'archive-1');
  });
}
