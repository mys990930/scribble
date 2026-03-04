// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drift_database.dart';

// ignore_for_file: type=lint
class $DailyPlansTable extends DailyPlans
    with TableInfo<$DailyPlansTable, DailyPlan> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyPlansTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, date, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_plans';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyPlan> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DailyPlan map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyPlan(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $DailyPlansTable createAlias(String alias) {
    return $DailyPlansTable(attachedDatabase, alias);
  }
}

class DailyPlan extends DataClass implements Insertable<DailyPlan> {
  final String id;
  final String name;
  final DateTime? date;
  final DateTime createdAt;
  final DateTime updatedAt;
  const DailyPlan({
    required this.id,
    required this.name,
    this.date,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || date != null) {
      map['date'] = Variable<DateTime>(date);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DailyPlansCompanion toCompanion(bool nullToAbsent) {
    return DailyPlansCompanion(
      id: Value(id),
      name: Value(name),
      date: date == null && nullToAbsent ? const Value.absent() : Value(date),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory DailyPlan.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyPlan(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      date: serializer.fromJson<DateTime?>(json['date']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'date': serializer.toJson<DateTime?>(date),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  DailyPlan copyWith({
    String? id,
    String? name,
    Value<DateTime?> date = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => DailyPlan(
    id: id ?? this.id,
    name: name ?? this.name,
    date: date.present ? date.value : this.date,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  DailyPlan copyWithCompanion(DailyPlansCompanion data) {
    return DailyPlan(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      date: data.date.present ? data.date.value : this.date,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyPlan(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('date: $date, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, date, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyPlan &&
          other.id == this.id &&
          other.name == this.name &&
          other.date == this.date &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DailyPlansCompanion extends UpdateCompanion<DailyPlan> {
  final Value<String> id;
  final Value<String> name;
  final Value<DateTime?> date;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const DailyPlansCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.date = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DailyPlansCompanion.insert({
    required String id,
    required String name,
    this.date = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<DailyPlan> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<DateTime>? date,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (date != null) 'date': date,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DailyPlansCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<DateTime?>? date,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return DailyPlansCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyPlansCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('date: $date, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlanDaysTable extends PlanDays with TableInfo<$PlanDaysTable, PlanDay> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlanDaysTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _planIdMeta = const VerificationMeta('planId');
  @override
  late final GeneratedColumn<String> planId = GeneratedColumn<String>(
    'plan_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES daily_plans (id)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<WeekdayD, String> weekday =
      GeneratedColumn<String>(
        'weekday',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<WeekdayD>($PlanDaysTable.$converterweekday);
  @override
  List<GeneratedColumn> get $columns => [planId, weekday];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'plan_days';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlanDay> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('plan_id')) {
      context.handle(
        _planIdMeta,
        planId.isAcceptableOrUnknown(data['plan_id']!, _planIdMeta),
      );
    } else if (isInserting) {
      context.missing(_planIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {planId, weekday};
  @override
  PlanDay map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlanDay(
      planId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plan_id'],
      )!,
      weekday: $PlanDaysTable.$converterweekday.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}weekday'],
        )!,
      ),
    );
  }

  @override
  $PlanDaysTable createAlias(String alias) {
    return $PlanDaysTable(attachedDatabase, alias);
  }

  static TypeConverter<WeekdayD, String> $converterweekday =
      const WeekdayConv();
}

class PlanDay extends DataClass implements Insertable<PlanDay> {
  final String planId;
  final WeekdayD weekday;
  const PlanDay({required this.planId, required this.weekday});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['plan_id'] = Variable<String>(planId);
    {
      map['weekday'] = Variable<String>(
        $PlanDaysTable.$converterweekday.toSql(weekday),
      );
    }
    return map;
  }

  PlanDaysCompanion toCompanion(bool nullToAbsent) {
    return PlanDaysCompanion(planId: Value(planId), weekday: Value(weekday));
  }

  factory PlanDay.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlanDay(
      planId: serializer.fromJson<String>(json['planId']),
      weekday: serializer.fromJson<WeekdayD>(json['weekday']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'planId': serializer.toJson<String>(planId),
      'weekday': serializer.toJson<WeekdayD>(weekday),
    };
  }

  PlanDay copyWith({String? planId, WeekdayD? weekday}) =>
      PlanDay(planId: planId ?? this.planId, weekday: weekday ?? this.weekday);
  PlanDay copyWithCompanion(PlanDaysCompanion data) {
    return PlanDay(
      planId: data.planId.present ? data.planId.value : this.planId,
      weekday: data.weekday.present ? data.weekday.value : this.weekday,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlanDay(')
          ..write('planId: $planId, ')
          ..write('weekday: $weekday')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(planId, weekday);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlanDay &&
          other.planId == this.planId &&
          other.weekday == this.weekday);
}

class PlanDaysCompanion extends UpdateCompanion<PlanDay> {
  final Value<String> planId;
  final Value<WeekdayD> weekday;
  final Value<int> rowid;
  const PlanDaysCompanion({
    this.planId = const Value.absent(),
    this.weekday = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlanDaysCompanion.insert({
    required String planId,
    required WeekdayD weekday,
    this.rowid = const Value.absent(),
  }) : planId = Value(planId),
       weekday = Value(weekday);
  static Insertable<PlanDay> custom({
    Expression<String>? planId,
    Expression<String>? weekday,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (planId != null) 'plan_id': planId,
      if (weekday != null) 'weekday': weekday,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlanDaysCompanion copyWith({
    Value<String>? planId,
    Value<WeekdayD>? weekday,
    Value<int>? rowid,
  }) {
    return PlanDaysCompanion(
      planId: planId ?? this.planId,
      weekday: weekday ?? this.weekday,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (planId.present) {
      map['plan_id'] = Variable<String>(planId.value);
    }
    if (weekday.present) {
      map['weekday'] = Variable<String>(
        $PlanDaysTable.$converterweekday.toSql(weekday.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlanDaysCompanion(')
          ..write('planId: $planId, ')
          ..write('weekday: $weekday, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RoutinesTable extends Routines with TableInfo<$RoutinesTable, Routine> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoutinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _planIdMeta = const VerificationMeta('planId');
  @override
  late final GeneratedColumn<String> planId = GeneratedColumn<String>(
    'plan_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES daily_plans (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _detailMeta = const VerificationMeta('detail');
  @override
  late final GeneratedColumn<String> detail = GeneratedColumn<String>(
    'detail',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _startTimeMeta = const VerificationMeta(
    'startTime',
  );
  @override
  late final GeneratedColumn<DateTime> startTime = GeneratedColumn<DateTime>(
    'start_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endTimeMeta = const VerificationMeta(
    'endTime',
  );
  @override
  late final GeneratedColumn<DateTime> endTime = GeneratedColumn<DateTime>(
    'end_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<RoutineTypeD, String> tag =
      GeneratedColumn<String>(
        'tag',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<RoutineTypeD>($RoutinesTable.$convertertag);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    planId,
    name,
    detail,
    startTime,
    endTime,
    tag,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'routines';
  @override
  VerificationContext validateIntegrity(
    Insertable<Routine> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('plan_id')) {
      context.handle(
        _planIdMeta,
        planId.isAcceptableOrUnknown(data['plan_id']!, _planIdMeta),
      );
    } else if (isInserting) {
      context.missing(_planIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('detail')) {
      context.handle(
        _detailMeta,
        detail.isAcceptableOrUnknown(data['detail']!, _detailMeta),
      );
    }
    if (data.containsKey('start_time')) {
      context.handle(
        _startTimeMeta,
        startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('end_time')) {
      context.handle(
        _endTimeMeta,
        endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_endTimeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Routine map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Routine(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      planId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plan_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      detail: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}detail'],
      )!,
      startTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_time'],
      )!,
      endTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_time'],
      )!,
      tag: $RoutinesTable.$convertertag.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}tag'],
        )!,
      ),
    );
  }

  @override
  $RoutinesTable createAlias(String alias) {
    return $RoutinesTable(attachedDatabase, alias);
  }

  static TypeConverter<RoutineTypeD, String> $convertertag =
      const RoutineTypeConv();
}

class Routine extends DataClass implements Insertable<Routine> {
  final String id;
  final String planId;
  final String name;
  final String detail;
  final DateTime startTime;
  final DateTime endTime;
  final RoutineTypeD tag;
  const Routine({
    required this.id,
    required this.planId,
    required this.name,
    required this.detail,
    required this.startTime,
    required this.endTime,
    required this.tag,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['plan_id'] = Variable<String>(planId);
    map['name'] = Variable<String>(name);
    map['detail'] = Variable<String>(detail);
    map['start_time'] = Variable<DateTime>(startTime);
    map['end_time'] = Variable<DateTime>(endTime);
    {
      map['tag'] = Variable<String>($RoutinesTable.$convertertag.toSql(tag));
    }
    return map;
  }

  RoutinesCompanion toCompanion(bool nullToAbsent) {
    return RoutinesCompanion(
      id: Value(id),
      planId: Value(planId),
      name: Value(name),
      detail: Value(detail),
      startTime: Value(startTime),
      endTime: Value(endTime),
      tag: Value(tag),
    );
  }

  factory Routine.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Routine(
      id: serializer.fromJson<String>(json['id']),
      planId: serializer.fromJson<String>(json['planId']),
      name: serializer.fromJson<String>(json['name']),
      detail: serializer.fromJson<String>(json['detail']),
      startTime: serializer.fromJson<DateTime>(json['startTime']),
      endTime: serializer.fromJson<DateTime>(json['endTime']),
      tag: serializer.fromJson<RoutineTypeD>(json['tag']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'planId': serializer.toJson<String>(planId),
      'name': serializer.toJson<String>(name),
      'detail': serializer.toJson<String>(detail),
      'startTime': serializer.toJson<DateTime>(startTime),
      'endTime': serializer.toJson<DateTime>(endTime),
      'tag': serializer.toJson<RoutineTypeD>(tag),
    };
  }

  Routine copyWith({
    String? id,
    String? planId,
    String? name,
    String? detail,
    DateTime? startTime,
    DateTime? endTime,
    RoutineTypeD? tag,
  }) => Routine(
    id: id ?? this.id,
    planId: planId ?? this.planId,
    name: name ?? this.name,
    detail: detail ?? this.detail,
    startTime: startTime ?? this.startTime,
    endTime: endTime ?? this.endTime,
    tag: tag ?? this.tag,
  );
  Routine copyWithCompanion(RoutinesCompanion data) {
    return Routine(
      id: data.id.present ? data.id.value : this.id,
      planId: data.planId.present ? data.planId.value : this.planId,
      name: data.name.present ? data.name.value : this.name,
      detail: data.detail.present ? data.detail.value : this.detail,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      tag: data.tag.present ? data.tag.value : this.tag,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Routine(')
          ..write('id: $id, ')
          ..write('planId: $planId, ')
          ..write('name: $name, ')
          ..write('detail: $detail, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('tag: $tag')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, planId, name, detail, startTime, endTime, tag);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Routine &&
          other.id == this.id &&
          other.planId == this.planId &&
          other.name == this.name &&
          other.detail == this.detail &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.tag == this.tag);
}

class RoutinesCompanion extends UpdateCompanion<Routine> {
  final Value<String> id;
  final Value<String> planId;
  final Value<String> name;
  final Value<String> detail;
  final Value<DateTime> startTime;
  final Value<DateTime> endTime;
  final Value<RoutineTypeD> tag;
  final Value<int> rowid;
  const RoutinesCompanion({
    this.id = const Value.absent(),
    this.planId = const Value.absent(),
    this.name = const Value.absent(),
    this.detail = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.tag = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RoutinesCompanion.insert({
    required String id,
    required String planId,
    required String name,
    this.detail = const Value.absent(),
    required DateTime startTime,
    required DateTime endTime,
    required RoutineTypeD tag,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       planId = Value(planId),
       name = Value(name),
       startTime = Value(startTime),
       endTime = Value(endTime),
       tag = Value(tag);
  static Insertable<Routine> custom({
    Expression<String>? id,
    Expression<String>? planId,
    Expression<String>? name,
    Expression<String>? detail,
    Expression<DateTime>? startTime,
    Expression<DateTime>? endTime,
    Expression<String>? tag,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (planId != null) 'plan_id': planId,
      if (name != null) 'name': name,
      if (detail != null) 'detail': detail,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (tag != null) 'tag': tag,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RoutinesCompanion copyWith({
    Value<String>? id,
    Value<String>? planId,
    Value<String>? name,
    Value<String>? detail,
    Value<DateTime>? startTime,
    Value<DateTime>? endTime,
    Value<RoutineTypeD>? tag,
    Value<int>? rowid,
  }) {
    return RoutinesCompanion(
      id: id ?? this.id,
      planId: planId ?? this.planId,
      name: name ?? this.name,
      detail: detail ?? this.detail,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      tag: tag ?? this.tag,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (planId.present) {
      map['plan_id'] = Variable<String>(planId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (detail.present) {
      map['detail'] = Variable<String>(detail.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<DateTime>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<DateTime>(endTime.value);
    }
    if (tag.present) {
      map['tag'] = Variable<String>(
        $RoutinesTable.$convertertag.toSql(tag.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoutinesCompanion(')
          ..write('id: $id, ')
          ..write('planId: $planId, ')
          ..write('name: $name, ')
          ..write('detail: $detail, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('tag: $tag, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MemosTable extends Memos with TableInfo<$MemosTable, Memo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MemosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _isResolvedMeta = const VerificationMeta(
    'isResolved',
  );
  @override
  late final GeneratedColumn<bool> isResolved = GeneratedColumn<bool>(
    'is_resolved',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_resolved" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _urgentOrderMeta = const VerificationMeta(
    'urgentOrder',
  );
  @override
  late final GeneratedColumn<int> urgentOrder = GeneratedColumn<int>(
    'urgent_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _dueAtMeta = const VerificationMeta('dueAt');
  @override
  late final GeneratedColumn<DateTime> dueAt = GeneratedColumn<DateTime>(
    'due_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _alarmEnabledMeta = const VerificationMeta(
    'alarmEnabled',
  );
  @override
  late final GeneratedColumn<bool> alarmEnabled = GeneratedColumn<bool>(
    'alarm_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("alarm_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _alarmNotifiedAtMeta = const VerificationMeta(
    'alarmNotifiedAt',
  );
  @override
  late final GeneratedColumn<DateTime> alarmNotifiedAt =
      GeneratedColumn<DateTime>(
        'alarm_notified_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    content,
    createdAt,
    isResolved,
    urgentOrder,
    dueAt,
    alarmEnabled,
    alarmNotifiedAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'memos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Memo> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('is_resolved')) {
      context.handle(
        _isResolvedMeta,
        isResolved.isAcceptableOrUnknown(data['is_resolved']!, _isResolvedMeta),
      );
    }
    if (data.containsKey('urgent_order')) {
      context.handle(
        _urgentOrderMeta,
        urgentOrder.isAcceptableOrUnknown(
          data['urgent_order']!,
          _urgentOrderMeta,
        ),
      );
    }
    if (data.containsKey('due_at')) {
      context.handle(
        _dueAtMeta,
        dueAt.isAcceptableOrUnknown(data['due_at']!, _dueAtMeta),
      );
    }
    if (data.containsKey('alarm_enabled')) {
      context.handle(
        _alarmEnabledMeta,
        alarmEnabled.isAcceptableOrUnknown(
          data['alarm_enabled']!,
          _alarmEnabledMeta,
        ),
      );
    }
    if (data.containsKey('alarm_notified_at')) {
      context.handle(
        _alarmNotifiedAtMeta,
        alarmNotifiedAt.isAcceptableOrUnknown(
          data['alarm_notified_at']!,
          _alarmNotifiedAtMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Memo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Memo(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      isResolved: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_resolved'],
      )!,
      urgentOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}urgent_order'],
      )!,
      dueAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_at'],
      ),
      alarmEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}alarm_enabled'],
      )!,
      alarmNotifiedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}alarm_notified_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $MemosTable createAlias(String alias) {
    return $MemosTable(attachedDatabase, alias);
  }
}

class Memo extends DataClass implements Insertable<Memo> {
  final String id;
  final String content;
  final DateTime createdAt;
  final bool isResolved;
  final int urgentOrder;
  final DateTime? dueAt;
  final bool alarmEnabled;
  final DateTime? alarmNotifiedAt;
  final DateTime updatedAt;
  const Memo({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.isResolved,
    required this.urgentOrder,
    this.dueAt,
    required this.alarmEnabled,
    this.alarmNotifiedAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['content'] = Variable<String>(content);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['is_resolved'] = Variable<bool>(isResolved);
    map['urgent_order'] = Variable<int>(urgentOrder);
    if (!nullToAbsent || dueAt != null) {
      map['due_at'] = Variable<DateTime>(dueAt);
    }
    map['alarm_enabled'] = Variable<bool>(alarmEnabled);
    if (!nullToAbsent || alarmNotifiedAt != null) {
      map['alarm_notified_at'] = Variable<DateTime>(alarmNotifiedAt);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  MemosCompanion toCompanion(bool nullToAbsent) {
    return MemosCompanion(
      id: Value(id),
      content: Value(content),
      createdAt: Value(createdAt),
      isResolved: Value(isResolved),
      urgentOrder: Value(urgentOrder),
      dueAt: dueAt == null && nullToAbsent
          ? const Value.absent()
          : Value(dueAt),
      alarmEnabled: Value(alarmEnabled),
      alarmNotifiedAt: alarmNotifiedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(alarmNotifiedAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Memo.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Memo(
      id: serializer.fromJson<String>(json['id']),
      content: serializer.fromJson<String>(json['content']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      isResolved: serializer.fromJson<bool>(json['isResolved']),
      urgentOrder: serializer.fromJson<int>(json['urgentOrder']),
      dueAt: serializer.fromJson<DateTime?>(json['dueAt']),
      alarmEnabled: serializer.fromJson<bool>(json['alarmEnabled']),
      alarmNotifiedAt: serializer.fromJson<DateTime?>(json['alarmNotifiedAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'content': serializer.toJson<String>(content),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'isResolved': serializer.toJson<bool>(isResolved),
      'urgentOrder': serializer.toJson<int>(urgentOrder),
      'dueAt': serializer.toJson<DateTime?>(dueAt),
      'alarmEnabled': serializer.toJson<bool>(alarmEnabled),
      'alarmNotifiedAt': serializer.toJson<DateTime?>(alarmNotifiedAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Memo copyWith({
    String? id,
    String? content,
    DateTime? createdAt,
    bool? isResolved,
    int? urgentOrder,
    Value<DateTime?> dueAt = const Value.absent(),
    bool? alarmEnabled,
    Value<DateTime?> alarmNotifiedAt = const Value.absent(),
    DateTime? updatedAt,
  }) => Memo(
    id: id ?? this.id,
    content: content ?? this.content,
    createdAt: createdAt ?? this.createdAt,
    isResolved: isResolved ?? this.isResolved,
    urgentOrder: urgentOrder ?? this.urgentOrder,
    dueAt: dueAt.present ? dueAt.value : this.dueAt,
    alarmEnabled: alarmEnabled ?? this.alarmEnabled,
    alarmNotifiedAt: alarmNotifiedAt.present
        ? alarmNotifiedAt.value
        : this.alarmNotifiedAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Memo copyWithCompanion(MemosCompanion data) {
    return Memo(
      id: data.id.present ? data.id.value : this.id,
      content: data.content.present ? data.content.value : this.content,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      isResolved: data.isResolved.present
          ? data.isResolved.value
          : this.isResolved,
      urgentOrder: data.urgentOrder.present
          ? data.urgentOrder.value
          : this.urgentOrder,
      dueAt: data.dueAt.present ? data.dueAt.value : this.dueAt,
      alarmEnabled: data.alarmEnabled.present
          ? data.alarmEnabled.value
          : this.alarmEnabled,
      alarmNotifiedAt: data.alarmNotifiedAt.present
          ? data.alarmNotifiedAt.value
          : this.alarmNotifiedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Memo(')
          ..write('id: $id, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt, ')
          ..write('isResolved: $isResolved, ')
          ..write('urgentOrder: $urgentOrder, ')
          ..write('dueAt: $dueAt, ')
          ..write('alarmEnabled: $alarmEnabled, ')
          ..write('alarmNotifiedAt: $alarmNotifiedAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    content,
    createdAt,
    isResolved,
    urgentOrder,
    dueAt,
    alarmEnabled,
    alarmNotifiedAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Memo &&
          other.id == this.id &&
          other.content == this.content &&
          other.createdAt == this.createdAt &&
          other.isResolved == this.isResolved &&
          other.urgentOrder == this.urgentOrder &&
          other.dueAt == this.dueAt &&
          other.alarmEnabled == this.alarmEnabled &&
          other.alarmNotifiedAt == this.alarmNotifiedAt &&
          other.updatedAt == this.updatedAt);
}

class MemosCompanion extends UpdateCompanion<Memo> {
  final Value<String> id;
  final Value<String> content;
  final Value<DateTime> createdAt;
  final Value<bool> isResolved;
  final Value<int> urgentOrder;
  final Value<DateTime?> dueAt;
  final Value<bool> alarmEnabled;
  final Value<DateTime?> alarmNotifiedAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const MemosCompanion({
    this.id = const Value.absent(),
    this.content = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isResolved = const Value.absent(),
    this.urgentOrder = const Value.absent(),
    this.dueAt = const Value.absent(),
    this.alarmEnabled = const Value.absent(),
    this.alarmNotifiedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MemosCompanion.insert({
    required String id,
    required String content,
    this.createdAt = const Value.absent(),
    this.isResolved = const Value.absent(),
    this.urgentOrder = const Value.absent(),
    this.dueAt = const Value.absent(),
    this.alarmEnabled = const Value.absent(),
    this.alarmNotifiedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       content = Value(content);
  static Insertable<Memo> custom({
    Expression<String>? id,
    Expression<String>? content,
    Expression<DateTime>? createdAt,
    Expression<bool>? isResolved,
    Expression<int>? urgentOrder,
    Expression<DateTime>? dueAt,
    Expression<bool>? alarmEnabled,
    Expression<DateTime>? alarmNotifiedAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (content != null) 'content': content,
      if (createdAt != null) 'created_at': createdAt,
      if (isResolved != null) 'is_resolved': isResolved,
      if (urgentOrder != null) 'urgent_order': urgentOrder,
      if (dueAt != null) 'due_at': dueAt,
      if (alarmEnabled != null) 'alarm_enabled': alarmEnabled,
      if (alarmNotifiedAt != null) 'alarm_notified_at': alarmNotifiedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MemosCompanion copyWith({
    Value<String>? id,
    Value<String>? content,
    Value<DateTime>? createdAt,
    Value<bool>? isResolved,
    Value<int>? urgentOrder,
    Value<DateTime?>? dueAt,
    Value<bool>? alarmEnabled,
    Value<DateTime?>? alarmNotifiedAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return MemosCompanion(
      id: id ?? this.id,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      isResolved: isResolved ?? this.isResolved,
      urgentOrder: urgentOrder ?? this.urgentOrder,
      dueAt: dueAt ?? this.dueAt,
      alarmEnabled: alarmEnabled ?? this.alarmEnabled,
      alarmNotifiedAt: alarmNotifiedAt ?? this.alarmNotifiedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (isResolved.present) {
      map['is_resolved'] = Variable<bool>(isResolved.value);
    }
    if (urgentOrder.present) {
      map['urgent_order'] = Variable<int>(urgentOrder.value);
    }
    if (dueAt.present) {
      map['due_at'] = Variable<DateTime>(dueAt.value);
    }
    if (alarmEnabled.present) {
      map['alarm_enabled'] = Variable<bool>(alarmEnabled.value);
    }
    if (alarmNotifiedAt.present) {
      map['alarm_notified_at'] = Variable<DateTime>(alarmNotifiedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MemosCompanion(')
          ..write('id: $id, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt, ')
          ..write('isResolved: $isResolved, ')
          ..write('urgentOrder: $urgentOrder, ')
          ..write('dueAt: $dueAt, ')
          ..write('alarmEnabled: $alarmEnabled, ')
          ..write('alarmNotifiedAt: $alarmNotifiedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $DailyPlansTable dailyPlans = $DailyPlansTable(this);
  late final $PlanDaysTable planDays = $PlanDaysTable(this);
  late final $RoutinesTable routines = $RoutinesTable(this);
  late final $MemosTable memos = $MemosTable(this);
  late final DailyPlanDao dailyPlanDao = DailyPlanDao(this as AppDatabase);
  late final RoutineDao routineDao = RoutineDao(this as AppDatabase);
  late final MemoDao memoDao = MemoDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    dailyPlans,
    planDays,
    routines,
    memos,
  ];
}

typedef $$DailyPlansTableCreateCompanionBuilder =
    DailyPlansCompanion Function({
      required String id,
      required String name,
      Value<DateTime?> date,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$DailyPlansTableUpdateCompanionBuilder =
    DailyPlansCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<DateTime?> date,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$DailyPlansTableReferences
    extends BaseReferences<_$AppDatabase, $DailyPlansTable, DailyPlan> {
  $$DailyPlansTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PlanDaysTable, List<PlanDay>> _planDaysRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.planDays,
    aliasName: $_aliasNameGenerator(db.dailyPlans.id, db.planDays.planId),
  );

  $$PlanDaysTableProcessedTableManager get planDaysRefs {
    final manager = $$PlanDaysTableTableManager(
      $_db,
      $_db.planDays,
    ).filter((f) => f.planId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_planDaysRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RoutinesTable, List<Routine>> _routinesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.routines,
    aliasName: $_aliasNameGenerator(db.dailyPlans.id, db.routines.planId),
  );

  $$RoutinesTableProcessedTableManager get routinesRefs {
    final manager = $$RoutinesTableTableManager(
      $_db,
      $_db.routines,
    ).filter((f) => f.planId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_routinesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$DailyPlansTableFilterComposer
    extends Composer<_$AppDatabase, $DailyPlansTable> {
  $$DailyPlansTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> planDaysRefs(
    Expression<bool> Function($$PlanDaysTableFilterComposer f) f,
  ) {
    final $$PlanDaysTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.planDays,
      getReferencedColumn: (t) => t.planId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlanDaysTableFilterComposer(
            $db: $db,
            $table: $db.planDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> routinesRefs(
    Expression<bool> Function($$RoutinesTableFilterComposer f) f,
  ) {
    final $$RoutinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.routines,
      getReferencedColumn: (t) => t.planId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutinesTableFilterComposer(
            $db: $db,
            $table: $db.routines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DailyPlansTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyPlansTable> {
  $$DailyPlansTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DailyPlansTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyPlansTable> {
  $$DailyPlansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> planDaysRefs<T extends Object>(
    Expression<T> Function($$PlanDaysTableAnnotationComposer a) f,
  ) {
    final $$PlanDaysTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.planDays,
      getReferencedColumn: (t) => t.planId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlanDaysTableAnnotationComposer(
            $db: $db,
            $table: $db.planDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> routinesRefs<T extends Object>(
    Expression<T> Function($$RoutinesTableAnnotationComposer a) f,
  ) {
    final $$RoutinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.routines,
      getReferencedColumn: (t) => t.planId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutinesTableAnnotationComposer(
            $db: $db,
            $table: $db.routines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DailyPlansTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyPlansTable,
          DailyPlan,
          $$DailyPlansTableFilterComposer,
          $$DailyPlansTableOrderingComposer,
          $$DailyPlansTableAnnotationComposer,
          $$DailyPlansTableCreateCompanionBuilder,
          $$DailyPlansTableUpdateCompanionBuilder,
          (DailyPlan, $$DailyPlansTableReferences),
          DailyPlan,
          PrefetchHooks Function({bool planDaysRefs, bool routinesRefs})
        > {
  $$DailyPlansTableTableManager(_$AppDatabase db, $DailyPlansTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyPlansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyPlansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyPlansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime?> date = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyPlansCompanion(
                id: id,
                name: name,
                date: date,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<DateTime?> date = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyPlansCompanion.insert(
                id: id,
                name: name,
                date: date,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DailyPlansTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({planDaysRefs = false, routinesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (planDaysRefs) db.planDays,
                    if (routinesRefs) db.routines,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (planDaysRefs)
                        await $_getPrefetchedData<
                          DailyPlan,
                          $DailyPlansTable,
                          PlanDay
                        >(
                          currentTable: table,
                          referencedTable: $$DailyPlansTableReferences
                              ._planDaysRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DailyPlansTableReferences(
                                db,
                                table,
                                p0,
                              ).planDaysRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.planId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (routinesRefs)
                        await $_getPrefetchedData<
                          DailyPlan,
                          $DailyPlansTable,
                          Routine
                        >(
                          currentTable: table,
                          referencedTable: $$DailyPlansTableReferences
                              ._routinesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DailyPlansTableReferences(
                                db,
                                table,
                                p0,
                              ).routinesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.planId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$DailyPlansTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyPlansTable,
      DailyPlan,
      $$DailyPlansTableFilterComposer,
      $$DailyPlansTableOrderingComposer,
      $$DailyPlansTableAnnotationComposer,
      $$DailyPlansTableCreateCompanionBuilder,
      $$DailyPlansTableUpdateCompanionBuilder,
      (DailyPlan, $$DailyPlansTableReferences),
      DailyPlan,
      PrefetchHooks Function({bool planDaysRefs, bool routinesRefs})
    >;
typedef $$PlanDaysTableCreateCompanionBuilder =
    PlanDaysCompanion Function({
      required String planId,
      required WeekdayD weekday,
      Value<int> rowid,
    });
typedef $$PlanDaysTableUpdateCompanionBuilder =
    PlanDaysCompanion Function({
      Value<String> planId,
      Value<WeekdayD> weekday,
      Value<int> rowid,
    });

final class $$PlanDaysTableReferences
    extends BaseReferences<_$AppDatabase, $PlanDaysTable, PlanDay> {
  $$PlanDaysTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DailyPlansTable _planIdTable(_$AppDatabase db) => db.dailyPlans
      .createAlias($_aliasNameGenerator(db.planDays.planId, db.dailyPlans.id));

  $$DailyPlansTableProcessedTableManager get planId {
    final $_column = $_itemColumn<String>('plan_id')!;

    final manager = $$DailyPlansTableTableManager(
      $_db,
      $_db.dailyPlans,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_planIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PlanDaysTableFilterComposer
    extends Composer<_$AppDatabase, $PlanDaysTable> {
  $$PlanDaysTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnWithTypeConverterFilters<WeekdayD, WeekdayD, String> get weekday =>
      $composableBuilder(
        column: $table.weekday,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  $$DailyPlansTableFilterComposer get planId {
    final $$DailyPlansTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planId,
      referencedTable: $db.dailyPlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DailyPlansTableFilterComposer(
            $db: $db,
            $table: $db.dailyPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlanDaysTableOrderingComposer
    extends Composer<_$AppDatabase, $PlanDaysTable> {
  $$PlanDaysTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get weekday => $composableBuilder(
    column: $table.weekday,
    builder: (column) => ColumnOrderings(column),
  );

  $$DailyPlansTableOrderingComposer get planId {
    final $$DailyPlansTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planId,
      referencedTable: $db.dailyPlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DailyPlansTableOrderingComposer(
            $db: $db,
            $table: $db.dailyPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlanDaysTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlanDaysTable> {
  $$PlanDaysTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumnWithTypeConverter<WeekdayD, String> get weekday =>
      $composableBuilder(column: $table.weekday, builder: (column) => column);

  $$DailyPlansTableAnnotationComposer get planId {
    final $$DailyPlansTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planId,
      referencedTable: $db.dailyPlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DailyPlansTableAnnotationComposer(
            $db: $db,
            $table: $db.dailyPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlanDaysTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlanDaysTable,
          PlanDay,
          $$PlanDaysTableFilterComposer,
          $$PlanDaysTableOrderingComposer,
          $$PlanDaysTableAnnotationComposer,
          $$PlanDaysTableCreateCompanionBuilder,
          $$PlanDaysTableUpdateCompanionBuilder,
          (PlanDay, $$PlanDaysTableReferences),
          PlanDay,
          PrefetchHooks Function({bool planId})
        > {
  $$PlanDaysTableTableManager(_$AppDatabase db, $PlanDaysTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlanDaysTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlanDaysTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlanDaysTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> planId = const Value.absent(),
                Value<WeekdayD> weekday = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlanDaysCompanion(
                planId: planId,
                weekday: weekday,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String planId,
                required WeekdayD weekday,
                Value<int> rowid = const Value.absent(),
              }) => PlanDaysCompanion.insert(
                planId: planId,
                weekday: weekday,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PlanDaysTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({planId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (planId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.planId,
                                referencedTable: $$PlanDaysTableReferences
                                    ._planIdTable(db),
                                referencedColumn: $$PlanDaysTableReferences
                                    ._planIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PlanDaysTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlanDaysTable,
      PlanDay,
      $$PlanDaysTableFilterComposer,
      $$PlanDaysTableOrderingComposer,
      $$PlanDaysTableAnnotationComposer,
      $$PlanDaysTableCreateCompanionBuilder,
      $$PlanDaysTableUpdateCompanionBuilder,
      (PlanDay, $$PlanDaysTableReferences),
      PlanDay,
      PrefetchHooks Function({bool planId})
    >;
typedef $$RoutinesTableCreateCompanionBuilder =
    RoutinesCompanion Function({
      required String id,
      required String planId,
      required String name,
      Value<String> detail,
      required DateTime startTime,
      required DateTime endTime,
      required RoutineTypeD tag,
      Value<int> rowid,
    });
typedef $$RoutinesTableUpdateCompanionBuilder =
    RoutinesCompanion Function({
      Value<String> id,
      Value<String> planId,
      Value<String> name,
      Value<String> detail,
      Value<DateTime> startTime,
      Value<DateTime> endTime,
      Value<RoutineTypeD> tag,
      Value<int> rowid,
    });

final class $$RoutinesTableReferences
    extends BaseReferences<_$AppDatabase, $RoutinesTable, Routine> {
  $$RoutinesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DailyPlansTable _planIdTable(_$AppDatabase db) => db.dailyPlans
      .createAlias($_aliasNameGenerator(db.routines.planId, db.dailyPlans.id));

  $$DailyPlansTableProcessedTableManager get planId {
    final $_column = $_itemColumn<String>('plan_id')!;

    final manager = $$DailyPlansTableTableManager(
      $_db,
      $_db.dailyPlans,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_planIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RoutinesTableFilterComposer
    extends Composer<_$AppDatabase, $RoutinesTable> {
  $$RoutinesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get detail => $composableBuilder(
    column: $table.detail,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<RoutineTypeD, RoutineTypeD, String> get tag =>
      $composableBuilder(
        column: $table.tag,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  $$DailyPlansTableFilterComposer get planId {
    final $$DailyPlansTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planId,
      referencedTable: $db.dailyPlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DailyPlansTableFilterComposer(
            $db: $db,
            $table: $db.dailyPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RoutinesTableOrderingComposer
    extends Composer<_$AppDatabase, $RoutinesTable> {
  $$RoutinesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get detail => $composableBuilder(
    column: $table.detail,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tag => $composableBuilder(
    column: $table.tag,
    builder: (column) => ColumnOrderings(column),
  );

  $$DailyPlansTableOrderingComposer get planId {
    final $$DailyPlansTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planId,
      referencedTable: $db.dailyPlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DailyPlansTableOrderingComposer(
            $db: $db,
            $table: $db.dailyPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RoutinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoutinesTable> {
  $$RoutinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get detail =>
      $composableBuilder(column: $table.detail, builder: (column) => column);

  GeneratedColumn<DateTime> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<DateTime> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumnWithTypeConverter<RoutineTypeD, String> get tag =>
      $composableBuilder(column: $table.tag, builder: (column) => column);

  $$DailyPlansTableAnnotationComposer get planId {
    final $$DailyPlansTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planId,
      referencedTable: $db.dailyPlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DailyPlansTableAnnotationComposer(
            $db: $db,
            $table: $db.dailyPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RoutinesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RoutinesTable,
          Routine,
          $$RoutinesTableFilterComposer,
          $$RoutinesTableOrderingComposer,
          $$RoutinesTableAnnotationComposer,
          $$RoutinesTableCreateCompanionBuilder,
          $$RoutinesTableUpdateCompanionBuilder,
          (Routine, $$RoutinesTableReferences),
          Routine,
          PrefetchHooks Function({bool planId})
        > {
  $$RoutinesTableTableManager(_$AppDatabase db, $RoutinesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoutinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoutinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoutinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> planId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> detail = const Value.absent(),
                Value<DateTime> startTime = const Value.absent(),
                Value<DateTime> endTime = const Value.absent(),
                Value<RoutineTypeD> tag = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RoutinesCompanion(
                id: id,
                planId: planId,
                name: name,
                detail: detail,
                startTime: startTime,
                endTime: endTime,
                tag: tag,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String planId,
                required String name,
                Value<String> detail = const Value.absent(),
                required DateTime startTime,
                required DateTime endTime,
                required RoutineTypeD tag,
                Value<int> rowid = const Value.absent(),
              }) => RoutinesCompanion.insert(
                id: id,
                planId: planId,
                name: name,
                detail: detail,
                startTime: startTime,
                endTime: endTime,
                tag: tag,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RoutinesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({planId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (planId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.planId,
                                referencedTable: $$RoutinesTableReferences
                                    ._planIdTable(db),
                                referencedColumn: $$RoutinesTableReferences
                                    ._planIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RoutinesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RoutinesTable,
      Routine,
      $$RoutinesTableFilterComposer,
      $$RoutinesTableOrderingComposer,
      $$RoutinesTableAnnotationComposer,
      $$RoutinesTableCreateCompanionBuilder,
      $$RoutinesTableUpdateCompanionBuilder,
      (Routine, $$RoutinesTableReferences),
      Routine,
      PrefetchHooks Function({bool planId})
    >;
typedef $$MemosTableCreateCompanionBuilder =
    MemosCompanion Function({
      required String id,
      required String content,
      Value<DateTime> createdAt,
      Value<bool> isResolved,
      Value<int> urgentOrder,
      Value<DateTime?> dueAt,
      Value<bool> alarmEnabled,
      Value<DateTime?> alarmNotifiedAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$MemosTableUpdateCompanionBuilder =
    MemosCompanion Function({
      Value<String> id,
      Value<String> content,
      Value<DateTime> createdAt,
      Value<bool> isResolved,
      Value<int> urgentOrder,
      Value<DateTime?> dueAt,
      Value<bool> alarmEnabled,
      Value<DateTime?> alarmNotifiedAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$MemosTableFilterComposer extends Composer<_$AppDatabase, $MemosTable> {
  $$MemosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isResolved => $composableBuilder(
    column: $table.isResolved,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get urgentOrder => $composableBuilder(
    column: $table.urgentOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueAt => $composableBuilder(
    column: $table.dueAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get alarmEnabled => $composableBuilder(
    column: $table.alarmEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get alarmNotifiedAt => $composableBuilder(
    column: $table.alarmNotifiedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MemosTableOrderingComposer
    extends Composer<_$AppDatabase, $MemosTable> {
  $$MemosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isResolved => $composableBuilder(
    column: $table.isResolved,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get urgentOrder => $composableBuilder(
    column: $table.urgentOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueAt => $composableBuilder(
    column: $table.dueAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get alarmEnabled => $composableBuilder(
    column: $table.alarmEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get alarmNotifiedAt => $composableBuilder(
    column: $table.alarmNotifiedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MemosTableAnnotationComposer
    extends Composer<_$AppDatabase, $MemosTable> {
  $$MemosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get isResolved => $composableBuilder(
    column: $table.isResolved,
    builder: (column) => column,
  );

  GeneratedColumn<int> get urgentOrder => $composableBuilder(
    column: $table.urgentOrder,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dueAt =>
      $composableBuilder(column: $table.dueAt, builder: (column) => column);

  GeneratedColumn<bool> get alarmEnabled => $composableBuilder(
    column: $table.alarmEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get alarmNotifiedAt => $composableBuilder(
    column: $table.alarmNotifiedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$MemosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MemosTable,
          Memo,
          $$MemosTableFilterComposer,
          $$MemosTableOrderingComposer,
          $$MemosTableAnnotationComposer,
          $$MemosTableCreateCompanionBuilder,
          $$MemosTableUpdateCompanionBuilder,
          (Memo, BaseReferences<_$AppDatabase, $MemosTable, Memo>),
          Memo,
          PrefetchHooks Function()
        > {
  $$MemosTableTableManager(_$AppDatabase db, $MemosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MemosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MemosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MemosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> isResolved = const Value.absent(),
                Value<int> urgentOrder = const Value.absent(),
                Value<DateTime?> dueAt = const Value.absent(),
                Value<bool> alarmEnabled = const Value.absent(),
                Value<DateTime?> alarmNotifiedAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MemosCompanion(
                id: id,
                content: content,
                createdAt: createdAt,
                isResolved: isResolved,
                urgentOrder: urgentOrder,
                dueAt: dueAt,
                alarmEnabled: alarmEnabled,
                alarmNotifiedAt: alarmNotifiedAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String content,
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> isResolved = const Value.absent(),
                Value<int> urgentOrder = const Value.absent(),
                Value<DateTime?> dueAt = const Value.absent(),
                Value<bool> alarmEnabled = const Value.absent(),
                Value<DateTime?> alarmNotifiedAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MemosCompanion.insert(
                id: id,
                content: content,
                createdAt: createdAt,
                isResolved: isResolved,
                urgentOrder: urgentOrder,
                dueAt: dueAt,
                alarmEnabled: alarmEnabled,
                alarmNotifiedAt: alarmNotifiedAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MemosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MemosTable,
      Memo,
      $$MemosTableFilterComposer,
      $$MemosTableOrderingComposer,
      $$MemosTableAnnotationComposer,
      $$MemosTableCreateCompanionBuilder,
      $$MemosTableUpdateCompanionBuilder,
      (Memo, BaseReferences<_$AppDatabase, $MemosTable, Memo>),
      Memo,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$DailyPlansTableTableManager get dailyPlans =>
      $$DailyPlansTableTableManager(_db, _db.dailyPlans);
  $$PlanDaysTableTableManager get planDays =>
      $$PlanDaysTableTableManager(_db, _db.planDays);
  $$RoutinesTableTableManager get routines =>
      $$RoutinesTableTableManager(_db, _db.routines);
  $$MemosTableTableManager get memos =>
      $$MemosTableTableManager(_db, _db.memos);
}
