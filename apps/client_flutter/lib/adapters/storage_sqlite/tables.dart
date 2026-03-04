part of 'drift_database.dart';

class Memos extends Table {
  TextColumn get id => text()();
  TextColumn get content => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isResolved => boolean().withDefault(const Constant(false))();
  IntColumn get urgentOrder => integer().withDefault(const Constant(0))();
  DateTimeColumn get dueAt => dateTime().nullable()();
  BoolColumn get alarmEnabled => boolean().withDefault(const Constant(false))();
  DateTimeColumn get alarmNotifiedAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
