import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scribble/adapters/api_client/api_memo_service.dart';
import 'package:scribble/adapters/share_intent/platform_share_payload.dart';
import 'package:scribble/adapters/share_intent/share_intent_adapter.dart';
import 'package:scribble/app_shell/di/default_url_fetcher.dart';
import 'package:scribble/app_shell/di/in_memory_archive_repository.dart';
import 'package:scribble/usecases/archive_usecases/archive_repository.dart';
import 'package:scribble/usecases/archive_usecases/shared_content.dart';
import 'package:scribble/usecases/archive_usecases/url_fetcher.dart';
import 'package:scribble/usecases/memo_usecases/memo_service.dart';

MemoService createMemoService(Ref ref) {
  return ApiMemoService();
}

ArchiveRepository createArchiveRepository(Ref ref) {
  return InMemoryArchiveRepository();
}

UrlFetcher createUrlFetcher(Ref ref) {
  return const DefaultUrlFetcher();
}

ShareIntentAdapter createShareIntentAdapter(
  Ref ref, {
  required Future<void> Function(SharedContent content) handleShare,
}) {
  return _UnsupportedShareIntentAdapter();
}

class _UnsupportedShareIntentAdapter implements ShareIntentAdapter {
  @override
  Future<void> handleIncoming(
    PlatformSharePayload payload, {
    required String category,
  }) {
    throw UnsupportedError('Share intent is not supported on web');
  }

  @override
  PlatformSharePayload parseFromPlatform(Map<String, dynamic> raw) {
    throw UnsupportedError('Share intent is not supported on web');
  }
}
