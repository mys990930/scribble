import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scribble/app_shell/di/di.dart';
import 'package:scribble/domain/archive_domain/archive_entry.dart';

final recentArchiveCategoriesProvider = FutureProvider<List<String>>((ref) async {
  final usecase = ref.watch(listRecentCategoriesUseCaseProvider);
  return usecase.execute();
});

final archivesProvider = FutureProvider<List<ArchiveEntry>>((ref) async {
  final category = ref.watch(selectedArchiveCategoryProvider);
  final query = ref.watch(archiveSearchQueryProvider).trim();

  if (query.isNotEmpty) {
    final usecase = ref.watch(searchArchivesUseCaseProvider);
    return usecase.execute(query: query, category: category);
  }

  final usecase = ref.watch(listArchivesUseCaseProvider);
  return usecase.execute(category: category);
});
