import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart' show Value;

import '../../domain/models/daily_plan.dart' as D;
import '../../domain/models/routine.dart' as D;
import '../../domain/models/validation.dart';
import '../db/drift_database.dart';
import '../db/daos/daily_plan_dao.dart';
import '../db/daos/routine_dao.dart';
import '../db/mappers.dart';

abstract class DailyPlanRepo {
  Future<List<D.DailyPlan>> loadAll();
  Future<void> upsert(D.DailyPlan plan);
  Future<void> delete(String planId);
  Future<List<D.Routine>> loadRoutines(String planId);
  Future<void> upsertRoutine(D.DailyPlan plan, D.Routine r);
  Future<void> deleteRoutine(String routineId);
}

class DriftDailyPlanRepo implements DailyPlanRepo {
  final AppDatabase db;
  final DailyPlanDao planDao;
  final RoutineDao routineDao;
  DriftDailyPlanRepo(this.db): planDao = DailyPlanDao(db), routineDao = RoutineDao(db);

  @override
  Future<List<D.DailyPlan>> loadAll() async {
    final plans = await planDao.getAllPlans();
    final result = <D.DailyPlan>[];
    for (final p in plans) {
      final ds = await planDao.getDays(p.id);
      final rs = await routineDao.getRoutinesByPlan(p.id);

      final days = ds.isEmpty ? null : ds.map((d)=> toDomainWeekday(d.weekday)).toList();
      final routines = rs.map((r)=> D.Routine(
        id: r.id,
        name: r.name,
        detail: r.detail,
        startTime: r.startTime,
        endTime: r.endTime,
        tag: toDomainTag(r.tag),
      )).toList();

      result.add(D.DailyPlan(
        id: p.id, name: p.name, date: p.date, days: days, routines: routines,
      ));
    }
    return result;
  }

  @override
  Future<void> upsert(D.DailyPlan plan) async {
    // 검증: 10분 스냅 + 겹침
    for (final r in plan.routines) {
      validateRoutineTimes(r.startTime, r.endTime);
    }
    validateNoOverlap(plan.routines.map((e)=>e.startTime), plan.routines.map((e)=>e.endTime));

    final comp = toPlanCompanion(plan);
    final daysComp = toPlanDaysCompanions(plan.id, plan.days);
    await planDao.upsertPlan(comp, daysComp);

    // 루틴은 전체 교체가 아니라 항목 단위 upsert를 권장
    // 여기서는 편의상 기존 루틴 유지 + 바뀐 것만 upsert하도록 둠
    for (final r in plan.routines) {
      await routineDao.upsertRoutine(toRoutineCompanion(plan: plan, r: r));
    }
  }

  @override
  Future<void> delete(String planId) => planDao.deletePlan(planId);

  @override
  Future<List<D.Routine>> loadRoutines(String planId) async {
    final rs = await routineDao.getRoutinesByPlan(planId);
    return rs.map((r)=> D.Routine(
      id: r.id, name: r.name, detail: r.detail,
      startTime: r.startTime, endTime: r.endTime, tag: toDomainTag(r.tag),
    )).toList();
  }

  @override
  Future<void> upsertRoutine(D.DailyPlan plan, D.Routine r) async {
    validateRoutineTimes(r.startTime, r.endTime);
    // 겹침 검증은 호출 측에서 최신 목록 불러와 검증 후 호출하거나,
    // 여기서도 최신 목록을 읽어 수행:
    final all = await loadRoutines(plan.id);
    final merged = [
      for (final x in all) if (x.id != r.id) x, r
    ];
    validateNoOverlap(merged.map((e)=>e.startTime), merged.map((e)=>e.endTime));
    await routineDao.upsertRoutine(toRoutineCompanion(plan: plan, r: r));
  }

  @override
  Future<void> deleteRoutine(String routineId) => routineDao.deleteRoutine(routineId);
}
