import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'daos/daily_plan_dao.dart';
import 'daos/routine_dao.dart';

part 'drift_database.g.dart';
part 'tables.dart';

@DriftDatabase(tables: [DailyPlans, PlanDays, Routines], daos: [DailyPlanDao, RoutineDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_open());
  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async => await m.createAll(),
    onUpgrade: (m, from, to) async {
      // schemaVersion 변경 시 마이그레이션 작성
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
