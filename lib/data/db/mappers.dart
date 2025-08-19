import 'package:drift/drift.dart' show Value;
import 'package:uuid/uuid.dart';

import '../../domain/models/daily_plan.dart' as D;
import '../../domain/models/routine.dart' as D;
import '../../domain/models/enums.dart' as Dm;
import 'drift_database.dart';

const _uuid = Uuid();
final _anchor = DateTime(1970,1,1); // 요일 플랜의 앵커 날짜

// enum 매핑
Dm.Weekday toDomainWeekday(WeekdayD d) => Dm.Weekday.values[d.index];
WeekdayD toDbWeekday(Dm.Weekday d) => WeekdayD.values[d.index];

Dm.RoutineType toDomainTag(RoutineTypeD d) => Dm.RoutineType.values[d.index];
RoutineTypeD toDbTag(Dm.RoutineType d) => RoutineTypeD.values[d.index];

// 요일 플랜: HH:MM만 유지하도록 앵커 날짜로 저장/복원
DateTime toAnchored(DateTime t) => DateTime(_anchor.year,_anchor.month,_anchor.day, t.hour, t.minute);
DateTime combineDateAndTime(DateTime date, DateTime anchoredTime) =>
    DateTime(date.year, date.month, date.day, anchoredTime.hour, anchoredTime.minute);

// ---- DailyPlan <-> Companions ----
DailyPlansCompanion toPlanCompanion(D.DailyPlan p) => DailyPlansCompanion(
  id: Value(p.id),
  name: Value(p.name),
  date: Value(p.date), // null if recurring
);

List<PlanDaysCompanion> toPlanDaysCompanions(String planId, List<Dm.Weekday>? days) {
  if (days == null) return [];
  return days.map((wd)=> PlanDaysCompanion(
    planId: Value(planId),
    weekday: Value(toDbWeekday(wd)),
  )).toList();
}

// ---- Routines ----
RoutinesCompanion toRoutineCompanion({
  required D.DailyPlan plan,
  required D.Routine r,
}) {
  final isOneOff = plan.isOneOff;
  final st = isOneOff ? r.startTime : toAnchored(r.startTime);
  final et = isOneOff ? r.endTime : toAnchored(r.endTime);
  return RoutinesCompanion(
    id: Value(r.id),
    planId: Value(plan.id),
    name: Value(r.name),
    detail: Value(r.detail),
    startTime: Value(st),
    endTime: Value(et),
    tag: Value(toDbTag(r.tag)),
  );
}
