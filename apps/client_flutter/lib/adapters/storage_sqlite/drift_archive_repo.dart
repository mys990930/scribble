import 'package:drift/drift.dart';
import 'package:scribble/adapters/storage_sqlite/drift_database.dart';
import 'package:scribble/domain/archive_domain/archive_domain.dart';
import 'package:scribble/usecases/archive_usecases/archive_repository.dart';

class DriftArchiveRepository implements ArchiveRepository {
  final AppDatabase db;
  bool _tableReady = false;

  DriftArchiveRepository(this.db);

  Future<void> _ensureTable() async {
    if (_tableReady) return;
    await db.customStatement('''
      CREATE TABLE IF NOT EXISTS archives (
        id TEXT PRIMARY KEY NOT NULL,
        url TEXT,
        title TEXT NOT NULL,
        body TEXT NOT NULL,
        image_url TEXT,
        category TEXT NOT NULL,
        capture_type TEXT NOT NULL,
        created_at INTEGER NOT NULL
      )
    ''');
    _tableReady = true;
  }

  @override
  Future<void> delete(String id) async {
    await _ensureTable();
    await db.customStatement('DELETE FROM archives WHERE id = ?', [id]);
  }

  @override
  Future<ArchiveEntry?> getById(String id) async {
    await _ensureTable();
    final rows = await db.customSelect(
      'SELECT * FROM archives WHERE id = ? LIMIT 1',
      variables: [
        Variable<String>(id),
      ],
    ).get();

    if (rows.isEmpty) return null;
    return _toEntry(rows.first.data);
  }

  @override
  Future<List<ArchiveEntry>> listAll() async {
    await _ensureTable();
    final rows = await db.customSelect(
      'SELECT * FROM archives ORDER BY created_at DESC',
    ).get();
    return rows.map((r) => _toEntry(r.data)).toList();
  }

  @override
  Future<List<ArchiveEntry>> listByCategory(String category) async {
    await _ensureTable();
    final rows = await db.customSelect(
      'SELECT * FROM archives WHERE category = ? ORDER BY created_at DESC',
      variables: [Variable<String>(category)],
    ).get();
    return rows.map((r) => _toEntry(r.data)).toList();
  }

  @override
  Future<List<String>> listRecentCategories() async {
    await _ensureTable();
    final rows = await db.customSelect(
      'SELECT category, MAX(created_at) AS latest FROM archives GROUP BY category ORDER BY latest DESC',
    ).get();
    return rows
        .map((r) => r.data['category'] as String?)
        .whereType<String>()
        .toList();
  }

  @override
  Future<void> save(ArchiveEntry entry) async {
    await _ensureTable();
    await db.customStatement(
      '''
      INSERT OR REPLACE INTO archives(
        id, url, title, body, image_url, category, capture_type, created_at
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?)
      ''',
      [
        entry.id,
        entry.url,
        entry.title,
        entry.body,
        entry.imageUrl,
        entry.category,
        entry.captureType.name,
        entry.createdAt.millisecondsSinceEpoch,
      ],
    );
  }

  @override
  Future<List<ArchiveEntry>> search(String query, {String? category}) async {
    await _ensureTable();
    final normalizedQuery = query.trim().toLowerCase();
    final normalizedCategory = category?.trim();

    final where = <String>[];
    final variables = <Variable>[];

    if (normalizedQuery.isNotEmpty) {
      where.add('(LOWER(title) LIKE ? OR LOWER(body) LIKE ? OR LOWER(category) LIKE ?)');
      final pattern = '%$normalizedQuery%';
      variables.add(Variable<String>(pattern));
      variables.add(Variable<String>(pattern));
      variables.add(Variable<String>(pattern));
    }

    if (normalizedCategory != null && normalizedCategory.isNotEmpty) {
      where.add('category = ?');
      variables.add(Variable<String>(normalizedCategory));
    }

    final querySql = StringBuffer('SELECT * FROM archives');
    if (where.isNotEmpty) {
      querySql.write(' WHERE ${where.join(' AND ')}');
    }
    querySql.write(' ORDER BY created_at DESC');

    final rows = await db.customSelect(
      querySql.toString(),
      variables: variables,
    ).get();
    return rows.map((r) => _toEntry(r.data)).toList();
  }

  ArchiveEntry _toEntry(Map<String, Object?> row) {
    final captureTypeRaw = (row['capture_type'] as String?) ?? 'fallback';
    final captureType = CaptureType.values.firstWhere(
      (e) => e.name == captureTypeRaw,
      orElse: () => CaptureType.fallback,
    );

    final createdAtEpoch = (row['created_at'] as int?) ?? 0;

    return ArchiveEntry.create(
      id: row['id'] as String,
      url: row['url'] as String?,
      title: row['title'] as String? ?? '',
      body: row['body'] as String? ?? '',
      imageUrl: row['image_url'] as String?,
      category: row['category'] as String? ?? 'inbox',
      captureType: captureType,
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAtEpoch),
    );
  }
}
