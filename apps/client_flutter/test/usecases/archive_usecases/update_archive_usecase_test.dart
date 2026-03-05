import 'package:flutter_test/flutter_test.dart';
import 'package:scribble/domain/archive_domain/archive_domain.dart';
import 'package:scribble/shared/kernel/app_error.dart';
import 'package:scribble/usecases/archive_usecases/archive_repository.dart';
import 'package:scribble/usecases/archive_usecases/update_archive_usecase.dart';

class _FakeArchiveRepository implements ArchiveRepository {
  ArchiveEntry? byId;
  ArchiveEntry? saved;

  @override
  Future<void> delete(String id) async {}

  @override
  Future<ArchiveEntry?> getById(String id) async => byId;

  @override
  Future<List<ArchiveEntry>> listAll() async => [];

  @override
  Future<List<ArchiveEntry>> listByCategory(String category) async => [];

  @override
  Future<List<String>> listRecentCategories() async => [];

  @override
  Future<void> save(ArchiveEntry entry) async {
    saved = entry;
  }

  @override
  Future<List<ArchiveEntry>> search(String query, {String? category}) async => [];
}

void main() {
  test('UpdateArchiveUseCase는 title/body/category를 업데이트한다', () async {
    final repo = _FakeArchiveRepository()
      ..byId = ArchiveEntry.create(
        id: 'a1',
        url: null,
        title: 'old',
        body: 'old body',
        imageUrl: null,
        category: 'old-cat',
        captureType: CaptureType.manual,
        createdAt: DateTime(2026, 3, 5),
      );

    final usecase = UpdateArchiveUseCase(archiveRepository: repo);
    final updated = await usecase.execute(
      archiveId: 'a1',
      title: 'new',
      body: 'new body',
      category: 'new-cat',
    );

    expect(updated.title, 'new');
    expect(repo.saved?.category, 'new-cat');
  });

  test('대상이 없으면 ARCHIVE_NOT_FOUND', () async {
    final repo = _FakeArchiveRepository()..byId = null;
    final usecase = UpdateArchiveUseCase(archiveRepository: repo);

    expect(
      () => usecase.execute(
        archiveId: 'missing',
        title: 'x',
        body: 'y',
        category: 'z',
      ),
      throwsA(isA<AppError>().having((e) => e.code, 'code', 'ARCHIVE_NOT_FOUND')),
    );
  });
}
