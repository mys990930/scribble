import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scribble/adapters/share_intent/share_intent_adapter.dart';
import 'package:scribble/usecases/archive_usecases/archive_repository.dart';
import 'package:scribble/usecases/archive_usecases/shared_content.dart';
import 'package:scribble/usecases/archive_usecases/url_fetcher.dart';
import 'package:scribble/usecases/memo_usecases/memo_service.dart';

MemoService createMemoService(Ref ref) {
  throw UnsupportedError('Platform not supported');
}

ArchiveRepository createArchiveRepository(Ref ref) {
  throw UnsupportedError('Platform not supported');
}

UrlFetcher createUrlFetcher(Ref ref) {
  throw UnsupportedError('Platform not supported');
}

ShareIntentAdapter createShareIntentAdapter(
  Ref ref, {
  required Future<void> Function(SharedContent content) handleShare,
}) {
  throw UnsupportedError('Platform not supported');
}
