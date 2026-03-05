import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'memo_dao.dart';

part 'drift_database.g.dart';
part 'tables.dart';

@DriftDatabase(
  tables: [Memos],
  daos: [MemoDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_open());

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async => await m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.createTable(memos);
      }
      if (from < 3) {
        await m.addColumn(memos, memos.dueAt);
      }
      if (from < 4) {
        await m.addColumn(memos, memos.alarmEnabled);
        await m.addColumn(memos, memos.alarmNotifiedAt);
      }
      if (from < 5) {
        await customStatement('''
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
      }
    },
  );
}

LazyDatabase _open() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'dailyplan.db'));
    return NativeDatabase.createInBackground(file);
  });
}
