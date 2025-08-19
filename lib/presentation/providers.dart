import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/db/drift_database.dart' as db;
import '../data/repo/daily_plan_repo_drift.dart';
import '../domain/models/daily_plan.dart';
import '../domain/models/enums.dart';

// DB
final databaseProvider = Provider<db.AppDatabase>((ref) => db.AppDatabase());

// Repo
final dailyPlanRepoProvider = Provider<DailyPlanRepo>((ref) {
  final db = ref.watch(databaseProvider);
  return DriftDailyPlanRepo(db);
});

// 상태
final allPlansProvider = FutureProvider<List<DailyPlan>>((ref) async {
  final repo = ref.watch(dailyPlanRepoProvider);
  return repo.loadAll();
});

final selectedDateProvider = StateProvider<DateTime>((_) => DateTime.now());

// 선택 날짜의 플랜 (우선순위: 1회성 날짜 == selectedDate → 아니면 요일 매칭 첫 번째)
Weekday weekdayOf(DateTime d) {
  switch (d.weekday) {
    case DateTime.monday: return Weekday.MON;
    case DateTime.tuesday: return Weekday.TUE;
    case DateTime.wednesday: return Weekday.WED;
    case DateTime.thursday: return Weekday.THU;
    case DateTime.friday: return Weekday.FRI;
    case DateTime.saturday: return Weekday.SAT;
    default: return Weekday.SUN;
  }
}

bool sameYMD(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

final planForSelectedDayProvider = Provider<DailyPlan?>((ref) {
  final asyncPlans = ref.watch(allPlansProvider);
  final day = ref.watch(selectedDateProvider);
  return asyncPlans.maybeWhen(
    data: (plans) {
      // 1) one-off exact match
      final oneOff = plans.where((p)=>p.date!=null).firstWhere(
        (p)=> sameYMD(p.date!, day),
        orElse: ()=> null as DailyPlan,
      );
      if (oneOff != null) return oneOff;

      // 2) weekday match
      final wd = weekdayOf(day);
      final candidates = plans.where((p)=> (p.days?.contains(wd) ?? false)).toList();
      return candidates.isEmpty ? null : candidates.first;
    },
    orElse: ()=> null,
  );
});
