import 'package:flutter_test/flutter_test.dart';
import 'package:scribble/domain/archive_domain/archive_entry.dart';
import 'package:scribble/usecases/archive_usecases/archive_repository.dart';
import 'package:scribble/usecases/archive_usecases/search_archives_usecase.dart';

class _FakeArchiveRepository implements ArchiveRepository {
  String? query;
  String? category;

  @override
  Future<void> delete(String id) async {}

  @override
  Future<ArchiveEntry?> getById(String id) async => null;

  @override
  Future<List<ArchiveEntry>> listAll() async => [];

  @override
  Future<List<ArchiveEntry>> listByCategory(String category) async => [];

  @override
  Future<List<String>> listRecentCategories() async => [];

  @override
  Future<void> save(ArchiveEntry entry) async {}

  @override
  Future<List<ArchiveEntry>> search(String query, {String? category}) async {
    this.query = query;
    this.category = category;
    return [];
  }
}

void main() {
  test('SearchArchivesUseCase는 query/category를 전달한다', () async {
    final repo = _FakeArchiveRepository();
    final usecase = SearchArchivesUseCase(archiveRepository: repo);

    await usecase.execute(query: ' hello ', category: ' web ');

    expect(repo.query, 'hello');
    expect(repo.category, 'web');
  });
}
