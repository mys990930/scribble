import 'package:scribble/domain/models/daily_plan.dart';

abstract class RoutineNotifier {
  Future<void> scheduleForPlan(DailyPlan plan);
  Future<void> cancelForPlan(String planId);
}

class LocalRoutineNotifier implements RoutineNotifier {
  // flutter_local_notifications 설정/초기화는 앱 레벨에서 1회 수행했다고 가정
  @override
  Future<void> scheduleForPlan(DailyPlan plan) async {
    await cancelForPlan(plan.id);
    // 요일 플랜: 다음 1주일 분량 예약
    // 1회성: 해당 날짜만 예약
    final now = DateTime.now();
    final routines = [...plan.routines];
    for (final r in routines) {
      final trigger = r.startTime.subtract(const Duration(minutes: 30));
      if (trigger.isAfter(now)) {
        // 여기에 실제 스케줄 등록 (id: plan.id + r.id 조합)
        // await _plugin.zonedSchedule(...);
      }
    }
  }

  @override
  Future<void> cancelForPlan(String planId) async {
    // planId 시작하는 알림 전체 취소
    // await _plugin.cancel(id)
  }
}
