import 'package:flutter_test/flutter_test.dart';
import 'package:scribble/domain/archive_domain/archive_entry.dart';
import 'package:scribble/usecases/archive_usecases/archive_repository.dart';
import 'package:scribble/usecases/archive_usecases/list_archives_usecase.dart';

class _FakeArchiveRepository implements ArchiveRepository {
  String? requestedCategory;

  @override
  Future<void> delete(String id) async {}

  @override
  Future<ArchiveEntry?> getById(String id) async => null;

  @override
  Future<List<ArchiveEntry>> listAll() async => [];

  @override
  Future<List<ArchiveEntry>> listByCategory(String category) async {
    requestedCategory = category;
    return [];
  }

  @override
  Future<void> save(ArchiveEntry entry) async {}

  @override
  Future<List<String>> listRecentCategories() async => [];

  @override
  Future<List<ArchiveEntry>> search(String query, {String? category}) async => [];
}

void main() {
  group('ListArchivesUseCase', () {
    test('category null이면 전체 조회', () async {
      final repo = _FakeArchiveRepository();
      final usecase = ListArchivesUseCase(archiveRepository: repo);

      await usecase.execute(category: null);

      expect(repo.requestedCategory, isNull);
    });

    test('category 지정이면 카테고리 조회', () async {
      final repo = _FakeArchiveRepository();
      final usecase = ListArchivesUseCase(archiveRepository: repo);

      await usecase.execute(category: '  web  ');

      expect(repo.requestedCategory, 'web');
    });
  });
}
