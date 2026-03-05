import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scribble/adapters/share_intent/share_intent_adapter.dart';
import 'package:scribble/usecases/archive_usecases/archive_repository.dart';
import 'package:scribble/usecases/archive_usecases/handle_share_usecase.dart';
import 'package:scribble/usecases/archive_usecases/list_archives_usecase.dart';
import 'package:scribble/usecases/archive_usecases/list_recent_categories_usecase.dart';
import 'package:scribble/usecases/archive_usecases/search_archives_usecase.dart';
import 'package:scribble/usecases/archive_usecases/update_archive_usecase.dart';
import 'package:scribble/usecases/archive_usecases/url_fetcher.dart';
import 'package:scribble/usecases/memo_usecases/memo_service.dart';

import 'di_stub.dart'
    if (dart.library.io) 'di_native.dart'
    if (dart.library.js_interop) 'di_web.dart' as platform;

final memoServiceProvider = Provider<MemoService>((ref) {
  return platform.createMemoService(ref);
});

final archiveRepositoryProvider = Provider<ArchiveRepository>((ref) {
  return platform.createArchiveRepository(ref);
});

final urlFetcherProvider = Provider<UrlFetcher>((ref) {
  return platform.createUrlFetcher(ref);
});

final handleShareUseCaseProvider = Provider<HandleShareUseCase>((ref) {
  return HandleShareUseCase(
    archiveRepository: ref.watch(archiveRepositoryProvider),
    urlFetcher: ref.watch(urlFetcherProvider),
  );
});

final listArchivesUseCaseProvider = Provider<ListArchivesUseCase>((ref) {
  return ListArchivesUseCase(
    archiveRepository: ref.watch(archiveRepositoryProvider),
  );
});

final shareIntentAdapterProvider = Provider<ShareIntentAdapter>((ref) {
  return platform.createShareIntentAdapter(
    ref,
    handleShare: (content) async {
      await ref.read(handleShareUseCaseProvider).execute(content);
    },
  );
});

final searchArchivesUseCaseProvider = Provider<SearchArchivesUseCase>((ref) {
  return SearchArchivesUseCase(
    archiveRepository: ref.watch(archiveRepositoryProvider),
  );
});

final listRecentCategoriesUseCaseProvider =
    Provider<ListRecentCategoriesUseCase>((ref) {
      return ListRecentCategoriesUseCase(
        archiveRepository: ref.watch(archiveRepositoryProvider),
      );
    });

final updateArchiveUseCaseProvider = Provider<UpdateArchiveUseCase>((ref) {
  return UpdateArchiveUseCase(
    archiveRepository: ref.watch(archiveRepositoryProvider),
  );
});

final selectedArchiveCategoryProvider = StateProvider<String?>((ref) => null);
final archiveSearchQueryProvider = StateProvider<String>((ref) => '');
final lastUsedArchiveCategoryProvider = StateProvider<String>((ref) => 'inbox');
