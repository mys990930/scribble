import 'package:scribble/domain/archive_domain/archive_entry.dart';

abstract class NoteIngestPort {
  Future<void> ingestFromArchive(ArchiveEntry entry);
}
