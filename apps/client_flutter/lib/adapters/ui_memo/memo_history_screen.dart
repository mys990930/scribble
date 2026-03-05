import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'memo_providers.dart';

class MemoHistoryScreen extends ConsumerWidget {
  const MemoHistoryScreen({super.key});

  String _dueText(DateTime? dueAt) {
    if (dueAt == null) return 'no due';
    final diff = dueAt.difference(DateTime.now());
    final abs = diff.abs();
    final h = abs.inHours;
    final m = abs.inMinutes % 60;
    final s = h > 0 ? '${h}h ${m}m' : '${abs.inMinutes}m';
    return diff.isNegative ? 'overdue $s' : 'due in $s';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncMemos = ref.watch(resolvedMemosProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Memo History')),
      body: asyncMemos.when(
        data: (memos) {
          if (memos.isEmpty) {
            return const Center(child: Text('No resolved memos yet.'));
          }
          return ListView.separated(
            itemCount: memos.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, i) {
              final m = memos[i];
              return ListTile(
                title: Text(
                  m.content,
                  style: const TextStyle(
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                subtitle: Text(
                  'Resolved: ${m.updatedAt} • ${_dueText(m.dueAt)}',
                ),
                trailing: TextButton(
                  onPressed: () async {
                    await ref
                        .read(memoServiceProvider)
                        .toggleResolved(m.id, false);
                    ref.invalidate(resolvedMemosProvider);
                    ref.invalidate(activeMemosProvider);
                  },
                  child: const Text('Unresolve'),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
