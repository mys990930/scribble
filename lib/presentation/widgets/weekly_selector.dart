import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scribble/presentation/providers.dart';
import 'package:scribble/presentation/themes/app_colors.dart';
import 'package:scribble/theme.dart';
import '../../domain/models/daily_plan.dart';

class WeeklySelector extends ConsumerWidget {
  final RoutinePalette palette;
  const WeeklySelector({super.key, this.palette = const RoutinePalette()});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedDateProvider);
    final startOfWeek = selected.subtract(
      Duration(days: (selected.weekday + 6) % 7),
    );
    final days = List.generate(
      7,
      (i) => DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day + i),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (final d in days)
          _DayCell(
            date: d,
            isToday: _isToday(d),
            isSelected: sameYMD(d, selected),
            palette: palette,
          ),
      ],
    );
  }

  bool _isToday(DateTime d) {
    final now = DateTime.now();
    return sameYMD(d, now);
  }
}

class _DayCell extends ConsumerWidget {
  final DateTime date;
  final bool isToday;
  final bool isSelected;
  final RoutinePalette palette;
  const _DayCell({
    required this.date,
    required this.isToday,
    required this.isSelected,
    required this.palette,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plan = ref.watch(planForSelectedDayProvider);
    final size = 42.0;
    final segments = _sampleSegments(plan, palette);

    return GestureDetector(
      onTap: () => ref.read(selectedDateProvider.notifier).state = date,
      child: Column(
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? AppColors.secondary : AppColors.textMuted,
              ),
              color: Colors.transparent,
            ),
            child: CustomPaint(painter: _WheelPainter(segments)),
          ),
          const SizedBox(height: 6),
          Text(
            _weekdayLabel(date),
            style: TextStyle(
              fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
              color: isToday ? AppColors.secondary : null,
            ),
          ),
          Text('${date.day}'),
        ],
      ),
    );
  }

  List<_Segment> _sampleSegments(DailyPlan? plan, RoutinePalette pal) {
    return [
      _Segment(ratio: 3, color: Color(pal.work)),
      _Segment(ratio: 2, color: Color(pal.rest)),
      _Segment(ratio: 1, color: Color(pal.sleep)),
    ];
  }

  String _weekdayLabel(DateTime d) =>
      ['월', '화', '수', '목', '금', '토', '일'][(d.weekday + 6) % 7];
}

class _Segment {
  final double ratio;
  final Color color;
  _Segment({required this.ratio, required this.color});
}

class _WheelPainter extends CustomPainter {
  final List<_Segment> segments;
  _WheelPainter(this.segments);

  @override
  void paint(Canvas canvas, Size size) {
    final total = segments.fold<double>(0, (s, e) => s + e.ratio);
    var start = -90.0;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width / 2.2
      ..strokeCap = StrokeCap.butt;
    final r = size.width / 2;
    final center = Offset(size.width / 2, size.height / 2);

    for (final s in segments) {
      final sweep = 360.0 * (s.ratio / total);
      paint.color = s.color;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: r / 1.1),
        _deg2rad(start),
        _deg2rad(sweep),
        false,
        paint,
      );
      start += sweep;
    }
  }

  double _deg2rad(double d) => d * 3.1415926535 / 180.0;

  @override
  bool shouldRepaint(covariant _WheelPainter old) => old.segments != segments;
}
