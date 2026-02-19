import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/memo.dart';
import '../providers.dart';
import '../themes/app_colors.dart';
import 'memo_edit_screen.dart';
import 'memo_history_screen.dart';

const _widgetChannel = MethodChannel('scribble/widget');

class NoteScreen extends ConsumerStatefulWidget {
  const NoteScreen({super.key});

  @override
  ConsumerState<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends ConsumerState<NoteScreen>
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
      await _syncWidget();
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
      _syncWidget();
    }
  }

  Future<void> _checkDueAlarms() async {
    final memos = await ref.read(memoRepoProvider).listActiveMemos();
    final now = DateTime.now();
    for (final m in memos) {
      if (!m.alarmEnabled || m.dueAt == null || m.alarmNotifiedAt != null)
        continue;
      final total = m.dueAt!.difference(m.createdAt).inMinutes;
      if (total <= 0) continue;
      final remaining = m.dueAt!.difference(now).inMinutes;
      final threshold = (total * 0.1).round().clamp(1, total);
      if (remaining <= threshold) {
        await _noti.show(
          m.id.hashCode,
          'Memo due soon',
          '${m.content} (${_dueText(m.dueAt)})',
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
            .read(memoRepoProvider)
            .updateMemo(m.copyWith(alarmNotifiedAt: now));
      }
    }
    ref.invalidate(activeMemosProvider);
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

  Future<void> _syncWidget() async {
    try {
      final memos = await ref.read(memoRepoProvider).listActiveMemos();
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
    } catch (_) {}
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
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ChoiceChip(
                          label: const Text('1h'),
                          selected: selectedPreset == const Duration(hours: 1),
                          onSelected: (_) => toggle(const Duration(hours: 1)),
                        ),
                        const SizedBox(width: 6),
                        ChoiceChip(
                          label: const Text('6h'),
                          selected: selectedPreset == const Duration(hours: 6),
                          onSelected: (_) => toggle(const Duration(hours: 6)),
                        ),
                        const SizedBox(width: 6),
                        ChoiceChip(
                          label: const Text('12h'),
                          selected: selectedPreset == const Duration(hours: 12),
                          onSelected: (_) => toggle(const Duration(hours: 12)),
                        ),
                        const SizedBox(width: 6),
                        ChoiceChip(
                          label: const Text('1d'),
                          selected: selectedPreset == const Duration(days: 1),
                          onSelected: (_) => toggle(const Duration(days: 1)),
                        ),
                      ],
                    ),
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
          .read(memoRepoProvider)
          .addMemo(
            result.content,
            dueAt: result.dueAt,
            alarmEnabled: result.alarmEnabled,
          );
      ref.invalidate(activeMemosProvider);
      await _syncWidget();
    }
  }

  Future<void> _openEditor(Memo memo) async {
    final updated = await Navigator.push<MemoEditResult>(
      context,
      MaterialPageRoute(builder: (_) => MemoEditScreen(memo: memo)),
    );
    if (updated == null) return;
    if (updated.deleteRequested) {
      await ref.read(memoRepoProvider).deleteMemo(memo.id);
      ref.invalidate(activeMemosProvider);
      await _syncWidget();
      return;
    }
    if (updated.content.isEmpty) return;

    await ref
        .read(memoRepoProvider)
        .updateMemo(
          memo.copyWith(
            content: updated.content,
            dueAt: updated.dueAt,
            alarmEnabled: updated.alarmEnabled,
            clearAlarmNotifiedAt: true,
          ),
        );
    ref.invalidate(activeMemosProvider);
    await _syncWidget();
  }

  @override
  Widget build(BuildContext context) {
    final asyncMemos = ref.watch(activeMemosProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
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
      body: asyncMemos.when(
        data: (memos) {
          if (memos.isEmpty)
            return const Center(child: Text('No memos yet. Tap + to add one.'));

          return ReorderableListView.builder(
            itemCount: memos.length,
            onReorder: (oldIndex, newIndex) async {
              final list = [...memos];
              if (newIndex > oldIndex) newIndex -= 1;
              final item = list.removeAt(oldIndex);
              list.insert(newIndex, item);
              await ref
                  .read(memoRepoProvider)
                  .reorderActiveMemos(list.map((e) => e.id).toList());
              ref.invalidate(activeMemosProvider);
              await _syncWidget();
            },
            itemBuilder: (context, index) {
              final memo = memos[index];
              final overdue = _isOverdue(memo.dueAt);
              return Card(
                key: ValueKey(memo.id),
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                          .read(memoRepoProvider)
                          .toggleResolved(memo.id, true);
                      ref.invalidate(activeMemosProvider);
                      ref.invalidate(resolvedMemosProvider);
                      await _syncWidget();
                    },
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        memo.alarmEnabled ? Icons.alarm_on : Icons.alarm_off,
                        size: 18,
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
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}

