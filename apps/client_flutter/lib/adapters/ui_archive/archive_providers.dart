import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scribble/app_shell/di/di.dart';
import 'package:scribble/domain/archive_domain/archive_entry.dart';

final archivesProvider = FutureProvider<List<ArchiveEntry>>((ref) async {
  final category = ref.watch(selectedArchiveCategoryProvider);
  final usecase = ref.watch(listArchivesUseCaseProvider);
  return usecase.execute(category: category);
});
