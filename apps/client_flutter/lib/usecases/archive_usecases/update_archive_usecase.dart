import 'package:scribble/domain/archive_domain/archive_domain.dart';
import 'package:scribble/usecases/archive_usecases/archive_repository.dart';
import 'package:scribble/usecases/archive_usecases/archive_usecase_errors.dart';

class UpdateArchiveUseCase {
  final ArchiveRepository _archiveRepository;

  UpdateArchiveUseCase({
    required ArchiveRepository archiveRepository,
  }) : _archiveRepository = archiveRepository;

  Future<ArchiveEntry> execute({
    required String archiveId,
    required String title,
    required String body,
    required String category,
  }) async {
    final current = await _archiveRepository.getById(archiveId);
    if (current == null) {
      throw archiveNotFoundError(archiveId);
    }

    final updated = ArchiveEntry.create(
      id: current.id,
      url: current.url,
      title: title,
      body: body,
      imageUrl: current.imageUrl,
      category: category,
      captureType: current.captureType,
      createdAt: current.createdAt,
    );

    await _archiveRepository.save(updated);
    return updated;
  }
}
