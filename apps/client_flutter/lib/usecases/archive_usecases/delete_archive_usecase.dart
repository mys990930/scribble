import 'package:scribble/usecases/archive_usecases/archive_repository.dart';

class DeleteArchiveUseCase {
  final ArchiveRepository _archiveRepository;

  DeleteArchiveUseCase({
    required ArchiveRepository archiveRepository,
  }) : _archiveRepository = archiveRepository;

  Future<void> execute(String archiveId) {
    return _archiveRepository.delete(archiveId);
  }
}
