import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scribble/adapters/ui_archive/archive_providers.dart';
import 'package:scribble/app_shell/di/di.dart';
import 'package:scribble/domain/archive_domain/archive_entry.dart';

class ArchiveDetailScreen extends ConsumerStatefulWidget {
  final ArchiveEntry entry;

  const ArchiveDetailScreen({
    super.key,
    required this.entry,
  });

  @override
  ConsumerState<ArchiveDetailScreen> createState() => _ArchiveDetailScreenState();
}

class _ArchiveDetailScreenState extends ConsumerState<ArchiveDetailScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _bodyController;
  late final TextEditingController _categoryController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.entry.title);
    _bodyController = TextEditingController(text: widget.entry.body);
    _categoryController = TextEditingController(text: widget.entry.category);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    try {
      await ref.read(updateArchiveUseCaseProvider).execute(
            archiveId: widget.entry.id,
            title: _titleController.text,
            body: _bodyController.text,
            category: _categoryController.text,
          );
      ref.invalidate(archivesProvider);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('수정 완료')),
      );
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('수정 실패: $e')),
      );
    }
  }

  Future<void> _delete() async {
    await ref.read(archiveRepositoryProvider).delete(widget.entry.id);
    ref.invalidate(archivesProvider);
    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('아카이브 상세'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _delete,
          ),
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _save,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: '제목'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _categoryController,
            decoration: const InputDecoration(labelText: '카테고리'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _bodyController,
            minLines: 8,
            maxLines: 14,
            decoration: const InputDecoration(labelText: '본문'),
          ),
          const SizedBox(height: 12),
          if (widget.entry.url != null && widget.entry.url!.isNotEmpty)
            Text('URL: ${widget.entry.url!}'),
        ],
      ),
    );
  }
}
