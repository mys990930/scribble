import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scribble/adapters/share_intent/method_channel_share_intent_adapter.dart';
import 'package:scribble/adapters/share_intent/share_intent_adapter.dart';
import 'package:scribble/adapters/storage_sqlite/drift_archive_repo.dart';
import 'package:scribble/adapters/storage_sqlite/drift_database.dart';
import 'package:scribble/adapters/storage_sqlite/drift_memo_repo.dart';
import 'package:scribble/app_shell/di/default_url_fetcher.dart';
import 'package:scribble/usecases/archive_usecases/archive_repository.dart';
import 'package:scribble/usecases/archive_usecases/shared_content.dart';
import 'package:scribble/usecases/archive_usecases/url_fetcher.dart';
import 'package:scribble/usecases/memo_usecases/memo_service.dart';

final _databaseProvider = Provider<AppDatabase>((ref) => AppDatabase());

final _archiveRepositoryProvider = Provider<ArchiveRepository>((ref) {
  final db = ref.watch(_databaseProvider);
  return DriftArchiveRepository(db);
});

MemoService createMemoService(Ref ref) {
  final db = ref.watch(_databaseProvider);
  return DriftMemoService(db);
}

ArchiveRepository createArchiveRepository(Ref ref) {
  return ref.watch(_archiveRepositoryProvider);
}

UrlFetcher createUrlFetcher(Ref ref) {
  return const DefaultUrlFetcher();
}

ShareIntentAdapter createShareIntentAdapter(
  Ref ref, {
  required Future<void> Function(SharedContent content) handleShare,
}) {
  return MethodChannelShareIntentAdapter(
    channel: const MethodChannel('scribble/share_intent'),
    handleShare: handleShare,
  );
}
