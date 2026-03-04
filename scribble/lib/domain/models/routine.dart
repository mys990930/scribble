import 'enums.dart';

class Routine {
  final String id;
  final String name;
  final String detail;
  final DateTime startTime; // 날짜 포함 (1회성/미러 복제시 기준으로 사용)
  final DateTime endTime; // start < end, 10분 단위
  final RoutineType tag;

  Routine({
    required this.id,
    required this.name,
    required this.detail,
    required this.startTime,
    required this.endTime,
    required this.tag,
  });

  int get minutes => endTime.difference(startTime).inMinutes;

  factory Routine.fromJson(Map<String, dynamic> json) {
    return Routine(
      id: json['id'] as String,
      name: json['name'] as String,
      detail: json['detail'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      tag: RoutineType.values.firstWhere(
        (e) => e.toString() == 'RoutineType.${json['tag']}',
        orElse: () => RoutineType.SLEEP,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'detail': detail,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'tag': tag.toString().split('.').last,
    };
  }
}
