import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/db/drift_database.dart' as db;
import '../data/repo/daily_plan_repo_drift.dart';
import '../data/repo/memo_repo_drift.dart';
import '../domain/models/daily_plan.dart';
import '../domain/models/enums.dart';
import '../domain/models/memo.dart';

// DB
final databaseProvider = Provider<db.AppDatabase>((ref) => db.AppDatabase());

// Repo
final dailyPlanRepoProvider = Provider<DailyPlanRepo>((ref) {
  final db = ref.watch(databaseProvider);
  return DriftDailyPlanRepo(db);
});

final memoRepoProvider = Provider<MemoRepo>((ref) {
  final db = ref.watch(databaseProvider);
  return DriftMemoRepo(db);
});

// 상태
final allPlansProvider = FutureProvider<List<DailyPlan>>((ref) async {
  final repo = ref.watch(dailyPlanRepoProvider);
  return repo.loadAll();
});

final activeMemosProvider = FutureProvider<List<Memo>>((ref) async {
  final repo = ref.watch(memoRepoProvider);
  return repo.listActiveMemos();
});

final resolvedMemosProvider = FutureProvider<List<Memo>>((ref) async {
  final repo = ref.watch(memoRepoProvider);
  return repo.listResolvedMemos();
});

final selectedDateProvider = StateProvider<DateTime>((_) => DateTime.now());

// 선택 날짜의 플랜 (우선순위: 1회성 날짜 == selectedDate → 아니면 요일 매칭 첫 번째)
Weekday weekdayOf(DateTime d) {
  switch (d.weekday) {
    case DateTime.monday:
      return Weekday.MON;
    case DateTime.tuesday:
      return Weekday.TUE;
    case DateTime.wednesday:
      return Weekday.WED;
    case DateTime.thursday:
      return Weekday.THU;
    case DateTime.friday:
      return Weekday.FRI;
    case DateTime.saturday:
      return Weekday.SAT;
    default:
      return Weekday.SUN;
  }
}

bool sameYMD(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

final planForSelectedDayProvider = Provider<DailyPlan?>((ref) {
  final asyncPlans = ref.watch(allPlansProvider);
  final day = ref.watch(selectedDateProvider);
  return asyncPlans.maybeWhen(
    data: (plans) {
      final oneOffMatches = plans.where(
        (p) => p.date != null && sameYMD(p.date!, day),
      );
      if (oneOffMatches.isNotEmpty) return oneOffMatches.first;

      final wd = weekdayOf(day);
      final candidates = plans
          .where((p) => (p.days?.contains(wd) ?? false))
          .toList();
      return candidates.isEmpty ? null : candidates.first;
    },
    orElse: () => null,
  );
});
