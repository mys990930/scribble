import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers.dart';
import '../widgets/weekly_selector.dart';
import '../widgets/plan_timeline.dart';

class DailyPlanScreen extends ConsumerWidget {
  const DailyPlanScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plan = ref.watch(planForSelectedDayProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Daily Plan')),
      body: Column(
        children: [
          const SizedBox(height: 8),
          const WeeklySelector(),
          const SizedBox(height: 12),
          if (plan == null)
            const Expanded(child: Center(child: Text('오늘 플랜이 없습니다.')))
          else
            Expanded(child: PlanTimeline(plan: plan)),
        ],
      ),
      floatingActionButton: plan == null
          ? null
          : FloatingActionButton.extended(
              onPressed: () {
                // TODO: 루틴 추가
              },
              icon: const Icon(Icons.add),
              label: const Text('루틴 추가'),
            ),
    );
  }
}
