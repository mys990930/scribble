import 'package:drift/drift.dart';
import '../drift_database.dart';

part 'routine_dao.g.dart';

@DriftAccessor(tables: [Routines])
class RoutineDao extends DatabaseAccessor<AppDatabase> with _$RoutineDaoMixin {
  RoutineDao(AppDatabase db) : super(db);

  Future<List<Routine>> getRoutinesByPlan(String planId) =>
      (select(routines)..where((t) => t.planId.equals(planId))).get();

  Future<void> upsertRoutine(RoutinesCompanion comp) async =>
      into(routines).insertOnConflictUpdate(comp);

  Future<void> deleteRoutine(String routineId) async =>
      (delete(routines)..where((t) => t.id.equals(routineId))).go();
}
