import 'package:flutter/material.dart';

class ArchiveShareCategorySheet extends StatefulWidget {
  final String defaultCategory;
  final ValueChanged<String> onConfirm;

  const ArchiveShareCategorySheet({
    super.key,
    required this.defaultCategory,
    required this.onConfirm,
  });

  @override
  State<ArchiveShareCategorySheet> createState() => _ArchiveShareCategorySheetState();
}

class _ArchiveShareCategorySheetState extends State<ArchiveShareCategorySheet> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.defaultCategory);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '카테고리 선택',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: '카테고리 입력',
              border: OutlineInputBorder(),
            ),
            autofocus: true,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('취소'),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: () {
                  final category = _controller.text.trim();
                  if (category.isEmpty) return;
                  widget.onConfirm(category);
                  Navigator.of(context).pop();
                },
                child: const Text('저장'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
