import 'memo.dart';

bool isOverdue(Memo memo, DateTime now) {
  return memo.dueAt != null && memo.dueAt!.isBefore(now);
}

Duration? remainingDuration(Memo memo, DateTime now) {
  if (memo.dueAt == null) return null;
  return memo.dueAt!.difference(now);
}

bool shouldNotifyAlarm(Memo memo, DateTime now) {
  if (!memo.alarmEnabled) return false;
  if (memo.dueAt == null) return false;
  if (memo.alarmNotifiedAt != null) return false;

  final total = memo.dueAt!.difference(memo.createdAt).inMinutes;
  if (total <= 0) return false;

  final remaining = memo.dueAt!.difference(now).inMinutes;
  final ratio = remaining / total;
  return ratio <= 0.1;
}
