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
