import 'package:drift/drift.dart';
import '../drift_database.dart';

part 'daily_plan_dao.g.dart';

@DriftAccessor(tables: [DailyPlans, PlanDays, Routines])
class DailyPlanDao extends DatabaseAccessor<AppDatabase> with _$DailyPlanDaoMixin {
  DailyPlanDao(AppDatabase db) : super(db);

  Future<List<DailyPlan>> getAllPlans() => select(dailyPlans).get();
  Future<void> upsertPlan(DailyPlansCompanion comp, List<PlanDaysCompanion> days) async {
    await transaction(() async {
      // upsert plan
      await into(dailyPlans).insertOnConflictUpdate(comp);
      // replace days
      await (delete(planDays)..where((t)=>t.planId.equals(comp.id.value))).go();
      if (days.isNotEmpty) {
        await batch((b) => b.insertAll(planDays, days));
      }
    });
  }

  Future<void> deletePlan(String planId) async {
    await transaction(() async {
      await (delete(planDays)..where((t)=>t.planId.equals(planId))).go();
      await (delete(routines)..where((t)=>t.planId.equals(planId))).go();
      await (delete(dailyPlans)..where((t)=>t.id.equals(planId))).go();
    });
  }

  // helper: days for plan
  Future<List<PlanDay>> getDays(String planId) =>
    (select(planDays)..where((t)=>t.planId.equals(planId))).get();
}
