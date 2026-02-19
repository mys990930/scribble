class Memo {
  final String id;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isResolved;
  final int urgentOrder;
  final DateTime? dueAt;
  final bool alarmEnabled;
  final DateTime? alarmNotifiedAt;

  const Memo({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.isResolved,
    required this.urgentOrder,
    required this.dueAt,
    required this.alarmEnabled,
    required this.alarmNotifiedAt,
  });

  Memo copyWith({
    String? id,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isResolved,
    int? urgentOrder,
    DateTime? dueAt,
    bool clearDueAt = false,
    bool? alarmEnabled,
    DateTime? alarmNotifiedAt,
    bool clearAlarmNotifiedAt = false,
  }) {
    return Memo(
      id: id ?? this.id,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isResolved: isResolved ?? this.isResolved,
      urgentOrder: urgentOrder ?? this.urgentOrder,
      dueAt: clearDueAt ? null : (dueAt ?? this.dueAt),
      alarmEnabled: alarmEnabled ?? this.alarmEnabled,
      alarmNotifiedAt: clearAlarmNotifiedAt
          ? null
          : (alarmNotifiedAt ?? this.alarmNotifiedAt),
    );
  }
}
