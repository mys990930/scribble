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
  Future<List<String>> listRecentCategories() async {
    final ordered = await listAll();
    final seen = <String>{};
    final categories = <String>[];
    for (final entry in ordered) {
      if (seen.add(entry.category)) {
        categories.add(entry.category);
      }
    }
    return categories;
  }

  @override
  Future<void> save(ArchiveEntry entry) async {
    _entries.removeWhere((e) => e.id == entry.id);
    _entries.add(entry);
  }

  @override
  Future<List<ArchiveEntry>> search(String query, {String? category}) async {
    final normalizedQuery = query.trim().toLowerCase();
    final normalizedCategory = category?.trim();

    Iterable<ArchiveEntry> items = await listAll();
    if (normalizedCategory != null && normalizedCategory.isNotEmpty) {
      items = items.where((e) => e.category == normalizedCategory);
    }

    if (normalizedQuery.isEmpty) {
      return items.toList();
    }

    return items.where((e) {
      return e.title.toLowerCase().contains(normalizedQuery) ||
          e.body.toLowerCase().contains(normalizedQuery) ||
          e.category.toLowerCase().contains(normalizedQuery);
    }).toList();
  }
}
