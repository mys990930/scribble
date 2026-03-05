import 'package:flutter/material.dart';

class ArchiveShareCategorySheet extends StatefulWidget {
  final String defaultCategory;
  final List<String> categories;
  final ValueChanged<String> onConfirm;

  const ArchiveShareCategorySheet({
    super.key,
    required this.defaultCategory,
    required this.categories,
    required this.onConfirm,
  });

  @override
  State<ArchiveShareCategorySheet> createState() => _ArchiveShareCategorySheetState();
}

class _ArchiveShareCategorySheetState extends State<ArchiveShareCategorySheet> {
  late String _selectedCategory;
  bool _isAddingCustom = false;
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.defaultCategory;
    _controller = TextEditingController(text: widget.defaultCategory);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chips = widget.categories.isEmpty
        ? <String>[widget.defaultCategory]
        : widget.categories;

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
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final category in chips)
                ChoiceChip(
                  label: Text(category),
                  selected: !_isAddingCustom && _selectedCategory == category,
                  onSelected: (_) {
                    setState(() {
                      _isAddingCustom = false;
                      _selectedCategory = category;
                      _controller.text = category;
                    });
                  },
                ),
              ActionChip(
                label: const Text('+ 새 카테고리'),
                onPressed: () {
                  setState(() {
                    _isAddingCustom = true;
                    _controller.selection = TextSelection(
                      baseOffset: 0,
                      extentOffset: _controller.text.length,
                    );
                  });
                },
              ),
            ],
          ),
          if (_isAddingCustom) ...[
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: '새 카테고리 입력',
                border: OutlineInputBorder(),
              ),
              autofocus: true,
            ),
          ],
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
                  final category = (_isAddingCustom
                          ? _controller.text
                          : _selectedCategory)
                      .trim();
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
