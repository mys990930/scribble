import 'package:scribble/usecases/archive_usecases/archive_repository.dart';
import 'package:scribble/usecases/archive_usecases/archive_usecase_errors.dart';
import 'package:scribble/usecases/archive_usecases/note_ingest_port.dart';

class SendToNoteUseCase {
  final ArchiveRepository _archiveRepository;
  final NoteIngestPort _noteIngestPort;

  SendToNoteUseCase({
    required ArchiveRepository archiveRepository,
    required NoteIngestPort noteIngestPort,
  })  : _archiveRepository = archiveRepository,
        _noteIngestPort = noteIngestPort;

  Future<void> execute(String archiveId) async {
    final archive = await _archiveRepository.getById(archiveId);
    if (archive == null) {
      throw archiveNotFoundError(archiveId);
    }
    await _noteIngestPort.ingestFromArchive(archive);
  }
}
