import 'package:flutter_test/flutter_test.dart';
import 'package:scribble/domain/archive_domain/archive_domain.dart';
import 'package:scribble/shared/kernel/app_error.dart';
import 'package:scribble/usecases/archive_usecases/archive_repository.dart';
import 'package:scribble/usecases/archive_usecases/note_ingest_port.dart';
import 'package:scribble/usecases/archive_usecases/send_to_note_usecase.dart';

class _FakeArchiveRepository implements ArchiveRepository {
  ArchiveEntry? byId;

  @override
  Future<void> delete(String id) async {}

  @override
  Future<ArchiveEntry?> getById(String id) async => byId;

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

class _FakeNoteIngestPort implements NoteIngestPort {
  ArchiveEntry? ingested;

  @override
  Future<void> ingestFromArchive(ArchiveEntry entry) async {
    ingested = entry;
  }
}

void main() {
  group('SendToNoteUseCase', () {
    test('archive가 있으면 ingest 호출', () async {
      final repo = _FakeArchiveRepository()
        ..byId = ArchiveEntry.create(
          id: 'a1',
          url: 'https://example.com',
          title: 'title',
          body: 'body',
          imageUrl: null,
          category: 'web',
          captureType: CaptureType.full,
          createdAt: DateTime(2026, 3, 5),
        );
      final notePort = _FakeNoteIngestPort();
      final usecase = SendToNoteUseCase(
        archiveRepository: repo,
        noteIngestPort: notePort,
      );

      await usecase.execute('a1');

      expect(notePort.ingested, isNotNull);
      expect(notePort.ingested!.id, 'a1');
    });

    test('archive가 없으면 ARCHIVE_NOT_FOUND', () async {
      final repo = _FakeArchiveRepository()..byId = null;
      final notePort = _FakeNoteIngestPort();
      final usecase = SendToNoteUseCase(
        archiveRepository: repo,
        noteIngestPort: notePort,
      );

      expect(
        () => usecase.execute('missing'),
        throwsA(isA<AppError>().having((e) => e.code, 'code', 'ARCHIVE_NOT_FOUND')),
      );
    });
  });
}
