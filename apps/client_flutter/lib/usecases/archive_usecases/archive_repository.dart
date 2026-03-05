import 'package:scribble/domain/archive_domain/archive_entry.dart';

abstract class ArchiveRepository {
  Future<List<ArchiveEntry>> listAll();
  Future<List<ArchiveEntry>> listByCategory(String category);
  Future<ArchiveEntry?> getById(String id);
  Future<void> save(ArchiveEntry entry);
  Future<void> delete(String id);
}
