import 'package:flutter_test/flutter_test.dart';
import 'package:scribble/domain/archive_domain/archive_domain.dart';
import 'package:scribble/shared/kernel/app_error.dart';
import 'package:scribble/usecases/archive_usecases/archive_repository.dart';
import 'package:scribble/usecases/archive_usecases/handle_share_usecase.dart';
import 'package:scribble/usecases/archive_usecases/shared_content.dart';
import 'package:scribble/usecases/archive_usecases/url_fetcher.dart';

class _FakeArchiveRepository implements ArchiveRepository {
  final List<ArchiveEntry> saved = [];

  @override
  Future<void> delete(String id) async {}

  @override
  Future<ArchiveEntry?> getById(String id) async => null;

  @override
  Future<List<ArchiveEntry>> listAll() async => [];

  @override
  Future<List<ArchiveEntry>> listByCategory(String category) async => [];

  @override
  Future<void> save(ArchiveEntry entry) async {
    saved.add(entry);
  }

  @override
  Future<List<String>> listRecentCategories() async => [];

  @override
  Future<List<ArchiveEntry>> search(String query, {String? category}) async => [];
}

class _FakeUrlFetcher implements UrlFetcher {
  FetchResult result = const FetchResult(
    title: null,
    body: null,
    imageUrl: null,
    success: false,
  );

  String? requestedUrl;

  @override
  Future<FetchResult> fetch(String url) async {
    requestedUrl = url;
    return result;
  }
}

void main() {
  group('HandleShareUseCase', () {
    test('URL 포함 + fetch 성공이면 full 저장', () async {
      final repo = _FakeArchiveRepository();
      final fetcher = _FakeUrlFetcher()
        ..result = const FetchResult(
          title: 'Fetched title',
          body: 'Fetched body',
          imageUrl: null,
          success: true,
        );

      final usecase = HandleShareUseCase(
        archiveRepository: repo,
        urlFetcher: fetcher,
        idGenerator: () => 'id-1',
        now: () => DateTime(2026, 3, 5),
      );

      final entry = await usecase.execute(
        const SharedContent(
          rawText: 'check this https://a.com',
          category: 'web',
        ),
      );

      expect(fetcher.requestedUrl, 'https://a.com');
      expect(entry.captureType, CaptureType.full);
      expect(entry.imageUrl, isNull);
      expect(repo.saved.single.captureType, CaptureType.full);
    });

    test('URL 포함 + fetch 실패면 fallback 저장', () async {
      final repo = _FakeArchiveRepository();
      final fetcher = _FakeUrlFetcher()
        ..result = const FetchResult(
          title: null,
          body: null,
          imageUrl: null,
          success: false,
        );

      final usecase = HandleShareUseCase(
        archiveRepository: repo,
        urlFetcher: fetcher,
        idGenerator: () => 'id-2',
        now: () => DateTime(2026, 3, 5),
      );

      final entry = await usecase.execute(
        const SharedContent(
          rawText: 'https://b.com text',
          category: 'web',
        ),
      );

      expect(entry.captureType, CaptureType.fallback);
      expect(entry.body, 'https://b.com text');
    });

    test('URL 없는 텍스트면 fallback 저장', () async {
      final repo = _FakeArchiveRepository();
      final fetcher = _FakeUrlFetcher();

      final usecase = HandleShareUseCase(
        archiveRepository: repo,
        urlFetcher: fetcher,
        idGenerator: () => 'id-3',
        now: () => DateTime(2026, 3, 5),
      );

      final entry = await usecase.execute(
        const SharedContent(
          rawText: 'plain text',
          category: 'memo',
        ),
      );

      expect(fetcher.requestedUrl, isNull);
      expect(entry.captureType, CaptureType.fallback);
    });

    test('빈 텍스트면 에러', () async {
      final repo = _FakeArchiveRepository();
      final fetcher = _FakeUrlFetcher();

      final usecase = HandleShareUseCase(
        archiveRepository: repo,
        urlFetcher: fetcher,
        idGenerator: () => 'id-4',
        now: () => DateTime(2026, 3, 5),
      );

      expect(
        () => usecase.execute(
          const SharedContent(
            rawText: '   ',
            category: 'memo',
          ),
        ),
        throwsA(isA<AppError>().having((e) => e.code, 'code', 'ARCHIVE_EMPTY_CONTENT')),
      );
    });

    test('여러 URL이면 첫 URL 사용', () async {
      final repo = _FakeArchiveRepository();
      final fetcher = _FakeUrlFetcher()
        ..result = const FetchResult(
          title: 't',
          body: 'b',
          imageUrl: null,
          success: true,
        );

      final usecase = HandleShareUseCase(
        archiveRepository: repo,
        urlFetcher: fetcher,
        idGenerator: () => 'id-5',
        now: () => DateTime(2026, 3, 5),
      );

      await usecase.execute(
        const SharedContent(
          rawText: 'https://first.com and https://second.com',
          category: 'web',
        ),
      );

      expect(fetcher.requestedUrl, 'https://first.com');
    });
  });
}
