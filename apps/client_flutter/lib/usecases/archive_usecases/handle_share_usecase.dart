import 'package:scribble/domain/archive_domain/archive_domain.dart';
import 'package:scribble/shared/kernel/entity_id.dart';
import 'package:scribble/usecases/archive_usecases/archive_repository.dart';
import 'package:scribble/usecases/archive_usecases/shared_content.dart';
import 'package:scribble/usecases/archive_usecases/url_fetcher.dart';

class HandleShareUseCase {
  final ArchiveRepository _archiveRepository;
  final UrlFetcher _urlFetcher;
  final String Function() _idGenerator;
  final DateTime Function() _now;

  HandleShareUseCase({
    required ArchiveRepository archiveRepository,
    required UrlFetcher urlFetcher,
    String Function()? idGenerator,
    DateTime Function()? now,
  })  : _archiveRepository = archiveRepository,
        _urlFetcher = urlFetcher,
        _idGenerator = idGenerator ?? newId,
        _now = now ?? DateTime.now;

  Future<ArchiveEntry> execute(SharedContent content) async {
    final rawText = content.rawText.trim();
    final firstUrl = _extractFirstUrl(rawText);
    final id = _idGenerator();
    final createdAt = _now();

    if (firstUrl != null) {
      final fetchResult = await _urlFetcher.fetch(firstUrl);
      if (fetchResult.success) {
        final entry = ArchiveEntry.create(
          id: id,
          url: firstUrl,
          title: (fetchResult.title ?? '').trim(),
          body: (fetchResult.body ?? '').trim(),
          imageUrl: fetchResult.imageUrl,
          category: content.category,
          captureType: CaptureType.full,
          createdAt: createdAt,
        );
        await _archiveRepository.save(entry);
        return entry;
      }
    }

    final entry = ArchiveEntry.create(
      id: id,
      url: firstUrl,
      title: '',
      body: rawText,
      imageUrl: null,
      category: content.category,
      captureType: CaptureType.fallback,
      createdAt: createdAt,
    );
    await _archiveRepository.save(entry);
    return entry;
  }

  String? _extractFirstUrl(String text) {
    if (text.isEmpty) return null;

    final matches = RegExp(r'https?://[^\s]+').allMatches(text);
    if (matches.isEmpty) return null;

    return matches.first.group(0);
  }
}
