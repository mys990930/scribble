part of 'drift_database.dart';

// ==== TypeConverters: enums ====
enum WeekdayD { MON, TUE, WED, THU, FRI, SAT, SUN }

enum RoutineTypeD { SLEEP, EAT, WORK, PLAY, SELFDEV }

class WeekdayConv extends TypeConverter<WeekdayD, String> {
  const WeekdayConv();
  @override
  WeekdayD fromSql(String from) =>
      WeekdayD.values.firstWhere((e) => e.name == from);
  @override
  String toSql(WeekdayD value) => value.name;
}

class RoutineTypeConv extends TypeConverter<RoutineTypeD, String> {
  const RoutineTypeConv();
  @override
  RoutineTypeD fromSql(String from) =>
      RoutineTypeD.values.firstWhere((e) => e.name == from);
  @override
  String toSql(RoutineTypeD value) => value.name;
}

// ==== Tables ====
class DailyPlans extends Table {
  TextColumn get id => text()(); // uuid string
  TextColumn get name => text()();
  DateTimeColumn get date => dateTime().nullable()(); // one-off only
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class PlanDays extends Table {
  TextColumn get planId => text().references(DailyPlans, #id)();
  TextColumn get weekday => text().map(const WeekdayConv())(); // MON..SUN
  @override
  Set<Column> get primaryKey => {planId, weekday};
}

class Routines extends Table {
  TextColumn get id => text()(); // uuid
  TextColumn get planId => text().references(DailyPlans, #id)();
  TextColumn get name => text()();
  TextColumn get detail => text().withDefault(const Constant(''))();
  // 요일 플랜은 1970-01-01 + HH:MM 저장, 1회성은 실제 날짜 저장
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime()();
  TextColumn get tag => text().map(const RoutineTypeConv())(); // SLEEP/...

  @override
  Set<Column> get primaryKey => {id};
}

class Memos extends Table {
  TextColumn get id => text()(); // uuid
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
