import 'package:scribble/domain/archive_domain/archive_entry.dart';
import 'package:scribble/usecases/archive_usecases/archive_repository.dart';

class ListArchivesUseCase {
  final ArchiveRepository _archiveRepository;

  ListArchivesUseCase({
    required ArchiveRepository archiveRepository,
  }) : _archiveRepository = archiveRepository;

  Future<List<ArchiveEntry>> execute({String? category}) {
    final normalizedCategory = category?.trim();
    if (normalizedCategory == null || normalizedCategory.isEmpty) {
      return _archiveRepository.listAll();
    }
    return _archiveRepository.listByCategory(normalizedCategory);
  }
}
