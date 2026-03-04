import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'domain/models/memo.dart';
import 'presentation/providers.dart';
import 'presentation/screens/calendar_screen.dart';
import 'presentation/screens/daily_plan_screen.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/memo_screen.dart';
import 'presentation/screens/note_screen.dart';
import 'presentation/themes/gmk_dots2_theme.dart';

class Routes {
  static const home = '/';
  static const dailyPlan = '/daily-plan';
  static const calendar = '/calendar';
  static const note = '/note';
  static const memo = '/memo';
}

class MyApp extends StatelessWidget {
  final String? initialRoute;
  const MyApp({super.key, this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scribble',
      debugShowCheckedModeBanner: false,
      theme: dotsTheme,
      initialRoute: initialRoute ?? Routes.home,
      routes: {
        Routes.home: (_) => const HomeScreen(),
        Routes.dailyPlan: (_) => const DailyPlanScreen(),
        Routes.calendar: (_) => const CalendarScreen(),
        Routes.note: (_) => const NoteScreen(),
        Routes.memo: (_) => const MemoScreen(),
      },
      builder: (context, child) =>
          _WidgetSyncGate(child: child ?? const SizedBox.shrink()),
    );
  }
}

class _WidgetSyncGate extends ConsumerStatefulWidget {
  final Widget child;
  const _WidgetSyncGate({required this.child});

  @override
  ConsumerState<_WidgetSyncGate> createState() => _WidgetSyncGateState();
}

class _WidgetSyncGateState extends ConsumerState<_WidgetSyncGate>
    with WidgetsBindingObserver {
  static const _widgetChannel = MethodChannel('scribble/widget');
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _consumePendingWidgetMemo();
      await _syncWidget();
    });
    _timer = Timer.periodic(const Duration(minutes: 5), (_) => _syncWidget());
  }

  @override
  void dispose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _handleAppResumed();
    }
  }

  Future<void> _handleAppResumed() async {
    await _consumePendingWidgetMemo();
    await _syncWidget();
  }


  Future<void> _consumePendingWidgetMemo() async {
    try {
      final raw = await _widgetChannel.invokeMethod<String>('consumePendingMemo');
      if (raw == null || raw.trim().isEmpty) return;

      String text = raw;
      DateTime? dueAt;
      try {
        final map = jsonDecode(raw) as Map<String, dynamic>;
        text = (map['text'] as String? ?? '').trim();
        final dueMinutes = map['dueMinutes'] as int?;
        if (dueMinutes != null && dueMinutes > 0) {
          dueAt = DateTime.now().add(Duration(minutes: dueMinutes));
        }
      } catch (_) {}

      if (text.isEmpty) return;
      await ref.read(memoRepoProvider).addMemo(text, dueAt: dueAt, alarmEnabled: false);
      ref.invalidate(activeMemosProvider);
    } catch (_) {}
  }

  Future<void> _syncWidget() async {
    try {
      final memos = await ref.read(memoRepoProvider).listActiveMemos();
      await _syncWidgetFromMemos(memos);
    } catch (_) {}
  }

  Future<void> _syncWidgetFromMemos(List<Memo> memos) async {
    final payload = jsonEncode(
      memos
          .take(25)
          .map(
            (m) => {
              'id': m.id,
              'content': m.content,
              'urgentOrder': m.urgentOrder,
              'dueAtEpochMs': m.dueAt?.millisecondsSinceEpoch,
            },
          )
          .toList(),
    );
    await _widgetChannel.invokeMethod('updateMemos', {'memosJson': payload});
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<List<Memo>>>(activeMemosProvider, (previous, next) {
      next.whenData((memos) {
        _syncWidgetFromMemos(memos);
      });
    });
    return widget.child;
  }
}

