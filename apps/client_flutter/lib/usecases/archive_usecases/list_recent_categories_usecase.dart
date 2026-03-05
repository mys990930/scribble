import 'package:scribble/usecases/archive_usecases/archive_repository.dart';

class ListRecentCategoriesUseCase {
  final ArchiveRepository _archiveRepository;

  ListRecentCategoriesUseCase({
    required ArchiveRepository archiveRepository,
  }) : _archiveRepository = archiveRepository;

  Future<List<String>> execute() {
    return _archiveRepository.listRecentCategories();
  }
}
