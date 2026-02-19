import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/daily_plan.dart';
import '../../domain/models/enums.dart';
import '../../presentation/providers.dart';
import '../../presentation/themes/app_colors.dart';
import '../../utils/time.dart';

class PlanTimeline extends ConsumerWidget {
  final DailyPlan plan;
  const PlanTimeline({super.key, required this.plan});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedDateProvider);
    final items = [...plan.routines]
      ..sort((a, b) => a.startTime.compareTo(b.startTime));

    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, i) {
        final r = items[i];

        final showStart = plan.isOneOff
            ? r.startTime
            : combineDate(selected, r.startTime);
        final showEnd = plan.isOneOff
            ? r.endTime
            : combineDate(selected, r.endTime);

        final color = _colorOf(groupOf(r.tag));
        return ListTile(
          leading: CircleAvatar(backgroundColor: color),
          title: Text(r.name),
          subtitle: Text(
            '${hhmm(showStart)} ~ ${hhmm(showEnd)} • ${r.tag.name}',
          ),
          trailing: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO
            },
          ),
        );
      },
    );
  }

  Color _colorOf(QuickTagGroup g) {
    switch (g) {
      case QuickTagGroup.WORK:
        return AppColors.primary;
      case QuickTagGroup.PLAY:
        return AppColors.tertiary;
      case QuickTagGroup.SLEEP:
        return AppColors.accentCool;
    }
  }
}
