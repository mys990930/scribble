import 'routine.dart';
import 'enums.dart';

class DailyPlan {
  final String id;
  final String name;
  final List<Weekday>? days; // 요일 플랜이면 사용
  final DateTime? date; // 1회성이면 사용
  final List<Routine> routines;

  DailyPlan({
    required this.id,
    required this.name,
    this.days,
    this.date,
    required this.routines,
  });
  bool get isOneOff => date != null;

factory DailyPlan.fromJson(Map<String, dynamic> j) => DailyPlan(
    id: j['id'],
    name: j['name'],
    days: j['days'] == null ? null
      : (j['days'] as List<dynamic>).map((s) => Weekday.values.firstWhere((e) => e.name == s)).toList(),
    date: j['date'] == null ? null : DateTime.parse(j['date']),
    routines: (j['routines'] as List<dynamic>).map((x) => Routine.fromJson(x)).toList(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'days': days?.map((e) => e.name).toList(),
    'date': date?.toIso8601String(),
    'routines': routines.map((r) => r.toJson()).toList(),
  };
}