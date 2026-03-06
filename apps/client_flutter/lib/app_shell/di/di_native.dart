import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scribble/adapters/api_client/mock_auth_service.dart';
import 'package:scribble/adapters/secure_storage/local_storage_auth_session_store.dart';
import 'package:scribble/adapters/share_intent/method_channel_share_intent_adapter.dart';
import 'package:scribble/adapters/share_intent/share_intent_adapter.dart';
import 'package:scribble/adapters/storage_sqlite/drift_archive_repo.dart';
import 'package:scribble/adapters/storage_sqlite/drift_database.dart';
import 'package:scribble/adapters/storage_sqlite/drift_memo_repo.dart';
import 'package:scribble/app_shell/di/default_url_fetcher.dart';
import 'package:scribble/shared/kernel/entity_id.dart';
import 'package:scribble/usecases/archive_usecases/archive_repository.dart';
import 'package:scribble/usecases/archive_usecases/shared_content.dart';
import 'package:scribble/usecases/archive_usecases/url_fetcher.dart';
import 'package:scribble/usecases/auth_usecases/auth_session_store.dart';
import 'package:scribble/usecases/auth_usecases/auth_service.dart';
import 'package:scribble/usecases/auth_usecases/auth_usecase.dart';
import 'package:scribble/usecases/auth_usecases/auth_usecase_impl.dart';
import 'package:scribble/usecases/memo_usecases/memo_service.dart';
import 'package:scribble/usecases/memo_usecases/memo_service_impl.dart';

final _databaseProvider = Provider<AppDatabase>((ref) => AppDatabase());

final _archiveRepositoryProvider = Provider<ArchiveRepository>((ref) {
  final db = ref.watch(_databaseProvider);
  return DriftArchiveRepository(db);
});

MemoService createMemoService(Ref ref) {
  final db = ref.watch(_databaseProvider);
  final repository = DriftMemoRepository(db);
  return MemoServiceImpl(
    repository: repository,
    idGenerator: newId,
    now: DateTime.now,
  );
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

// Auth providers
AuthSessionStore createAuthSessionStore(Ref ref) {
  // TODO: Replace with SecureAuthSessionStore when flutter_secure_storage is added
  return LocalStorageAuthSessionStore();
}

AuthService createAuthService(Ref ref) {
  // Use MockAuthService for development/testing
  // Change to ApiAuthService for production with real backend
  return MockAuthService();
}

AuthUsecase createAuthUsecase(Ref ref) {
  return AuthUsecaseImpl(
    authService: createAuthService(ref),
    sessionStore: createAuthSessionStore(ref),
  );
}
