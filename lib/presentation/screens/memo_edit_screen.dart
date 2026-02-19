import 'package:flutter/material.dart';
import '../../domain/models/memo.dart';

class MemoEditResult {
  final String content;
  final DateTime? dueAt;
  final bool alarmEnabled;
  final bool deleteRequested;
  const MemoEditResult({
    required this.content,
    required this.dueAt,
    required this.alarmEnabled,
    this.deleteRequested = false,
  });
}

class MemoEditScreen extends StatefulWidget {
  final Memo memo;
  const MemoEditScreen({super.key, required this.memo});

  @override
  State<MemoEditScreen> createState() => _MemoEditScreenState();
}

class _MemoEditScreenState extends State<MemoEditScreen> {
  late final TextEditingController _controller;
  final TextEditingController _customHoursController = TextEditingController();
  DateTime? _dueAt;
  Duration? _selectedPreset;
  bool _alarmEnabled = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.memo.content);
    _dueAt = widget.memo.dueAt;
    _alarmEnabled = widget.memo.alarmEnabled;
  }

  @override
  void dispose() {
    _controller.dispose();
    _customHoursController.dispose();
    super.dispose();
  }

  void _togglePreset(Duration d) {
    setState(() {
      if (_selectedPreset == d) {
        _selectedPreset = null;
        _dueAt = null;
      } else {
        _selectedPreset = d;
        _dueAt = DateTime.now().add(d);
      }
    });
  }

  void _applyCustomHours() {
    final h = double.tryParse(_customHoursController.text.trim());
    if (h == null || h <= 0) return;
    setState(() {
      _selectedPreset = null;
      _dueAt = DateTime.now().add(Duration(minutes: (h * 60).round()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Memo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              Navigator.pop(
                context,
                MemoEditResult(
                  content: widget.memo.content,
                  dueAt: widget.memo.dueAt,
                  alarmEnabled: widget.memo.alarmEnabled,
                  deleteRequested: true,
                ),
              );
            },
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(
                context,
                MemoEditResult(
                  content: _controller.text.trim(),
                  dueAt: _dueAt,
                  alarmEnabled: _alarmEnabled,
                ),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _controller,
              maxLines: null,
              autofocus: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Write memo',
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              children: [
                ChoiceChip(
                  label: const Text('1h'),
                  selected: _selectedPreset == const Duration(hours: 1),
                  onSelected: (_) => _togglePreset(const Duration(hours: 1)),
                ),
                ChoiceChip(
                  label: const Text('6h'),
                  selected: _selectedPreset == const Duration(hours: 6),
                  onSelected: (_) => _togglePreset(const Duration(hours: 6)),
                ),
                ChoiceChip(
                  label: const Text('12h'),
                  selected: _selectedPreset == const Duration(hours: 12),
                  onSelected: (_) => _togglePreset(const Duration(hours: 12)),
                ),
                ChoiceChip(
                  label: const Text('1d'),
                  selected: _selectedPreset == const Duration(days: 1),
                  onSelected: (_) => _togglePreset(const Duration(days: 1)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _customHoursController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Custom due (hours)',
                      isDense: true,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: _applyCustomHours,
                  child: const Text('Set'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(_alarmEnabled ? Icons.alarm_on : Icons.alarm_off),
                const SizedBox(width: 6),
                const Text('Alarm'),
                Switch(
                  value: _alarmEnabled,
                  onChanged: (v) => setState(() => _alarmEnabled = v),
                ),
              ],
            ),
            Text(_dueAt == null ? 'No due date' : 'Due: $_dueAt'),
          ],
        ),
      ),
    );
  }
}
