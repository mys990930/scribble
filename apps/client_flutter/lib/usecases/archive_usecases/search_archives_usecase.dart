import 'package:scribble/domain/archive_domain/archive_entry.dart';
import 'package:scribble/usecases/archive_usecases/archive_repository.dart';

class SearchArchivesUseCase {
  final ArchiveRepository _archiveRepository;

  SearchArchivesUseCase({
    required ArchiveRepository archiveRepository,
  }) : _archiveRepository = archiveRepository;

  Future<List<ArchiveEntry>> execute({
    required String query,
    String? category,
  }) {
    return _archiveRepository.search(query.trim(), category: category?.trim());
  }
}
