import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:scribble/domain/memo_domain/memo.dart';
import 'memo_providers.dart';
import 'package:scribble/shared/ui/app_colors.dart';
import 'memo_edit_screen.dart';
import 'memo_edit_result.dart';
import 'memo_history_screen.dart';

class MemoScreen extends ConsumerStatefulWidget {
  const MemoScreen({super.key});

  @override
  ConsumerState<MemoScreen> createState() => _MemoScreenState();
}

class _MemoScreenState extends ConsumerState<MemoScreen>
    with WidgetsBindingObserver {
  final FlutterLocalNotificationsPlugin _noti =
      FlutterLocalNotificationsPlugin();
  Timer? _alarmTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initNotifications();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _checkDueAlarms();
    });
    _alarmTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      _checkDueAlarms();
    });
  }

  Future<void> _initNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    await _noti.initialize(settings);

    final androidPlugin = _noti
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await androidPlugin?.requestNotificationsPermission();

    const channel = AndroidNotificationChannel(
      'memo_due_channel',
      'Memo Due Alerts',
      description: 'Alerts when memo due time is near',
      importance: Importance.defaultImportance,
    );
    await androidPlugin?.createNotificationChannel(channel);
  }

  @override
  void dispose() {
    _alarmTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkDueAlarms();
    }
  }

  Future<void> _checkDueAlarms() async {
    final now = DateTime.now();
    final targets = await ref.read(memoServiceProvider).checkAlarms(now);
    for (final memo in targets) {
      await _noti.show(
        memo.id.hashCode,
        'Memo due soon',
        '${memo.content} (${_dueText(memo.dueAt)})',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'memo_due_channel',
            'Memo Due Alerts',
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
          ),
        ),
      );
      await ref
          .read(memoServiceProvider)
          .updateMemo(memo.copyWith(alarmNotifiedAt: now));
    }
    if (targets.isNotEmpty) {
      await _refreshActiveMemos();
    }
  }

  String _dueText(DateTime? dueAt) {
    if (dueAt == null) return 'no due';
    final now = DateTime.now();
    final diff = dueAt.difference(now);
    final abs = diff.abs();
    final h = abs.inHours;
    final m = abs.inMinutes % 60;
    final s = h > 0 ? '${h}h ${m}m' : '${abs.inMinutes}m';
    return diff.isNegative ? 'overdue $s' : 'due in $s';
  }

  bool _isOverdue(DateTime? dueAt) =>
      dueAt != null && dueAt.isBefore(DateTime.now());

  Future<void> _refreshActiveMemos() async {
    await ref.read(activeMemosProvider.notifier).refresh();
  }

  Future<void> _showAddDialog() async {
    final controller = TextEditingController();
    Duration? selectedPreset;
    DateTime? dueAt;
    bool alarmEnabled = false;

    final result = await showDialog<MemoEditResult>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          void toggle(Duration d) {
            setState(() {
              if (selectedPreset == d) {
                selectedPreset = null;
                dueAt = null;
              } else {
                selectedPreset = d;
                dueAt = DateTime.now().add(d);
              }
            });
          }

          return AlertDialog(
            title: const Text('Add memo'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: controller,
                    autofocus: true,
                    maxLines: 4,
                    decoration: const InputDecoration(hintText: 'Write memo'),
                  ),
                  const SizedBox(height: 10),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Hours'),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    children: [
                      ChoiceChip(
                        label: const Text('1h'),
                        selected: selectedPreset == const Duration(hours: 1),
                        onSelected: (_) => toggle(const Duration(hours: 1)),
                      ),
                      ChoiceChip(
                        label: const Text('2h'),
                        selected: selectedPreset == const Duration(hours: 2),
                        onSelected: (_) => toggle(const Duration(hours: 2)),
                      ),
                      ChoiceChip(
                        label: const Text('3h'),
                        selected: selectedPreset == const Duration(hours: 3),
                        onSelected: (_) => toggle(const Duration(hours: 3)),
                      ),
                      ChoiceChip(
                        label: const Text('6h'),
                        selected: selectedPreset == const Duration(hours: 6),
                        onSelected: (_) => toggle(const Duration(hours: 6)),
                      ),
                      ChoiceChip(
                        label: const Text('12h'),
                        selected: selectedPreset == const Duration(hours: 12),
                        onSelected: (_) => toggle(const Duration(hours: 12)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Days / Weeks'),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    children: [
                      ChoiceChip(
                        label: const Text('1d'),
                        selected: selectedPreset == const Duration(days: 1),
                        onSelected: (_) => toggle(const Duration(days: 1)),
                      ),
                      ChoiceChip(
                        label: const Text('3d'),
                        selected: selectedPreset == const Duration(days: 3),
                        onSelected: (_) => toggle(const Duration(days: 3)),
                      ),
                      ChoiceChip(
                        label: const Text('1w'),
                        selected: selectedPreset == const Duration(days: 7),
                        onSelected: (_) => toggle(const Duration(days: 7)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(alarmEnabled ? Icons.alarm_on : Icons.alarm_off),
                      const SizedBox(width: 6),
                      const Text('Alarm'),
                      Switch(
                        value: alarmEnabled,
                        onChanged: (v) => setState(() => alarmEnabled = v),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(
                  context,
                  MemoEditResult(
                    content: controller.text.trim(),
                    dueAt: dueAt,
                    alarmEnabled: alarmEnabled,
                  ),
                ),
                child: const Text('Add'),
              ),
            ],
          );
        },
      ),
    );

    if (result != null && result.content.isNotEmpty) {
      await ref
          .read(memoServiceProvider)
          .addMemo(
            result.content,
            dueAt: result.dueAt,
            alarmEnabled: result.alarmEnabled,
          );
      await _refreshActiveMemos();
    }
  }

  Future<void> _openEditor(Memo memo) async {
    final updated = await Navigator.push<MemoEditResult>(
      context,
      MaterialPageRoute(builder: (_) => MemoEditScreen(memo: memo)),
    );
    if (updated == null) return;
    if (updated.deleteRequested) {
      await ref.read(memoServiceProvider).deleteMemo(memo.id);
      await _refreshActiveMemos();
      return;
    }
    if (updated.content.isEmpty) return;

    await ref
        .read(memoServiceProvider)
        .updateMemo(
          memo.copyWith(
            content: updated.content,
            dueAt: updated.dueAt,
            clearDueAt: updated.dueAt == null,
            alarmEnabled: updated.alarmEnabled,
            clearAlarmNotifiedAt: true,
          ),
        );
    await _refreshActiveMemos();
  }

  @override
  Widget build(BuildContext context) {
    final asyncMemos = ref.watch(activeMemosProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Memos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MemoHistoryScreen()),
            ),
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          final memos = asyncMemos.valueOrNull ?? const <Memo>[];

          Widget child;
          if (memos.isEmpty) {
            child = ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(height: 160),
                Center(child: Text('No memos yet. Tap + to add one.')),
              ],
            );
          } else {
            child = ReorderableListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: memos.length,
              onReorder: (oldIndex, newIndex) async {
                final list = [...memos];
                if (newIndex > oldIndex) newIndex -= 1;
                final item = list.removeAt(oldIndex);
                list.insert(newIndex, item);
                await ref
                    .read(memoServiceProvider)
                    .reorderActiveMemos(list.map((e) => e.id).toList());
                await _refreshActiveMemos();
              },
              itemBuilder: (context, index) {
                final memo = memos[index];
                final overdue = _isOverdue(memo.dueAt);
                return Card(
                  key: ValueKey(memo.id),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    onTap: () => _openEditor(memo),
                    title: Text(
                      memo.content,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      _dueText(memo.dueAt),
                      style: TextStyle(
                        color: overdue
                            ? AppColors.overdue
                            : AppColors.textSecondary,
                      ),
                    ),
                    leading: IconButton(
                      icon: const Icon(Icons.check_circle_outline),
                      onPressed: () async {
                        await ref
                            .read(memoServiceProvider)
                            .toggleResolved(memo.id, true);
                        await _refreshActiveMemos();
                        ref.invalidate(resolvedMemosProvider);
                      },
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            memo.alarmEnabled
                                ? Icons.alarm_on
                                : Icons.alarm_off,
                            size: 18,
                          ),
                          onPressed: () async {
                            await ref
                                .read(memoServiceProvider)
                                .updateMemo(
                                  memo.copyWith(
                                    alarmEnabled: !memo.alarmEnabled,
                                    clearAlarmNotifiedAt: true,
                                  ),
                                );
                            await _refreshActiveMemos();
                          },
                        ),
                        ReorderableDragStartListener(
                          index: index,
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(Icons.drag_handle),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return RefreshIndicator(onRefresh: _refreshActiveMemos, child: child);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
