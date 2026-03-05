import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scribble/adapters/ui_archive/archive_providers.dart';
import 'package:scribble/adapters/ui_archive/archive_share_category_sheet.dart';
import 'package:scribble/app_shell/di/di.dart';

class ArchiveScreen extends ConsumerStatefulWidget {
  const ArchiveScreen({super.key});

  @override
  ConsumerState<ArchiveScreen> createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends ConsumerState<ArchiveScreen> {
  bool _handledInitialShare = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_handledInitialShare) return;
    _handledInitialShare = true;

    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is! Map<String, dynamic>) return;
    final raw = args['pendingShare'];
    if (raw is! Map<String, dynamic>) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showCategorySheet(raw);
    });
  }

  Future<void> _showCategorySheet(Map<String, dynamic> raw) async {
    if (!mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return ArchiveShareCategorySheet(
          defaultCategory: 'inbox',
          onConfirm: (category) async {
            await _handleShare(raw, category);
          },
        );
      },
    );
  }

  Future<void> _handleShare(Map<String, dynamic> raw, String category) async {
    try {
      final adapter = ref.read(shareIntentAdapterProvider);
      final payload = adapter.parseFromPlatform(raw);
      await adapter.handleIncoming(payload, category: category);
      ref.read(selectedArchiveCategoryProvider.notifier).state = category;
      ref.invalidate(archivesProvider);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('아카이브 저장 완료')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('저장 실패: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final archives = ref.watch(archivesProvider);
    final selectedCategory = ref.watch(selectedArchiveCategoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Archive'),
        actions: [
          if (selectedCategory != null)
            TextButton(
              onPressed: () {
                ref.read(selectedArchiveCategoryProvider.notifier).state = null;
                ref.invalidate(archivesProvider);
              },
              child: const Text('전체'),
            ),
        ],
      ),
      body: archives.when(
        data: (items) {
          if (items.isEmpty) {
            return const Center(child: Text('아카이브가 비어있어'));
          }
          return ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                title: Text(item.title.isEmpty ? '(제목 없음)' : item.title),
                subtitle: Text(
                  '${item.category} · ${item.captureType.name}\n${item.body}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                isThreeLine: true,
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('로드 실패: $error')),
      ),
    );
  }
}
