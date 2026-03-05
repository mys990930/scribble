import 'package:scribble/domain/archive_domain/archive_entry.dart';
import 'package:scribble/usecases/archive_usecases/archive_repository.dart';

class InMemoryArchiveRepository implements ArchiveRepository {
  final List<ArchiveEntry> _entries = [];

  @override
  Future<void> delete(String id) async {
    _entries.removeWhere((e) => e.id == id);
  }

  @override
  Future<ArchiveEntry?> getById(String id) async {
    for (final entry in _entries) {
      if (entry.id == id) return entry;
    }
    return null;
  }

  @override
  Future<List<ArchiveEntry>> listAll() async {
    final list = List<ArchiveEntry>.from(_entries);
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  @override
  Future<List<ArchiveEntry>> listByCategory(String category) async {
    final normalized = category.trim();
    final list = _entries.where((e) => e.category == normalized).toList();
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  @override
  Future<void> save(ArchiveEntry entry) async {
    _entries.removeWhere((e) => e.id == entry.id);
    _entries.add(entry);
  }
}
