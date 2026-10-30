// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $AccountsTable extends Accounts
    with TableInfo<$AccountsTable, AccountSettings> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _accountNicknameMeta = const VerificationMeta(
    'accountNickname',
  );
  @override
  late final GeneratedColumn<String> accountNickname = GeneratedColumn<String>(
    'account_nickname',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _virtualBalanceMeta = const VerificationMeta(
    'virtualBalance',
  );
  @override
  late final GeneratedColumn<int> virtualBalance = GeneratedColumn<int>(
    'virtual_balance',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1000000000),
  );
  static const VerificationMeta _currencyCodeMeta = const VerificationMeta(
    'currencyCode',
  );
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
    'currency_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('KRW'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    accountNickname,
    virtualBalance,
    currencyCode,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'account_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AccountSettings> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('account_nickname')) {
      context.handle(
        _accountNicknameMeta,
        accountNickname.isAcceptableOrUnknown(
          data['account_nickname']!,
          _accountNicknameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_accountNicknameMeta);
    }
    if (data.containsKey('virtual_balance')) {
      context.handle(
        _virtualBalanceMeta,
        virtualBalance.isAcceptableOrUnknown(
          data['virtual_balance']!,
          _virtualBalanceMeta,
        ),
      );
    }
    if (data.containsKey('currency_code')) {
      context.handle(
        _currencyCodeMeta,
        currencyCode.isAcceptableOrUnknown(
          data['currency_code']!,
          _currencyCodeMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AccountSettings map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AccountSettings(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      accountNickname: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_nickname'],
      )!,
      virtualBalance: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}virtual_balance'],
      )!,
      currencyCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency_code'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AccountsTable createAlias(String alias) {
    return $AccountsTable(attachedDatabase, alias);
  }
}

class AccountSettings extends DataClass implements Insertable<AccountSettings> {
  final int id;
  final String accountNickname;
  final int virtualBalance;
  final String currencyCode;
  final int createdAt;
  final int updatedAt;
  const AccountSettings({
    required this.id,
    required this.accountNickname,
    required this.virtualBalance,
    required this.currencyCode,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['account_nickname'] = Variable<String>(accountNickname);
    map['virtual_balance'] = Variable<int>(virtualBalance);
    map['currency_code'] = Variable<String>(currencyCode);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  AccountsCompanion toCompanion(bool nullToAbsent) {
    return AccountsCompanion(
      id: Value(id),
      accountNickname: Value(accountNickname),
      virtualBalance: Value(virtualBalance),
      currencyCode: Value(currencyCode),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory AccountSettings.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AccountSettings(
      id: serializer.fromJson<int>(json['id']),
      accountNickname: serializer.fromJson<String>(json['accountNickname']),
      virtualBalance: serializer.fromJson<int>(json['virtualBalance']),
      currencyCode: serializer.fromJson<String>(json['currencyCode']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'accountNickname': serializer.toJson<String>(accountNickname),
      'virtualBalance': serializer.toJson<int>(virtualBalance),
      'currencyCode': serializer.toJson<String>(currencyCode),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  AccountSettings copyWith({
    int? id,
    String? accountNickname,
    int? virtualBalance,
    String? currencyCode,
    int? createdAt,
    int? updatedAt,
  }) => AccountSettings(
    id: id ?? this.id,
    accountNickname: accountNickname ?? this.accountNickname,
    virtualBalance: virtualBalance ?? this.virtualBalance,
    currencyCode: currencyCode ?? this.currencyCode,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  AccountSettings copyWithCompanion(AccountsCompanion data) {
    return AccountSettings(
      id: data.id.present ? data.id.value : this.id,
      accountNickname: data.accountNickname.present
          ? data.accountNickname.value
          : this.accountNickname,
      virtualBalance: data.virtualBalance.present
          ? data.virtualBalance.value
          : this.virtualBalance,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AccountSettings(')
          ..write('id: $id, ')
          ..write('accountNickname: $accountNickname, ')
          ..write('virtualBalance: $virtualBalance, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    accountNickname,
    virtualBalance,
    currencyCode,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AccountSettings &&
          other.id == this.id &&
          other.accountNickname == this.accountNickname &&
          other.virtualBalance == this.virtualBalance &&
          other.currencyCode == this.currencyCode &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class AccountsCompanion extends UpdateCompanion<AccountSettings> {
  final Value<int> id;
  final Value<String> accountNickname;
  final Value<int> virtualBalance;
  final Value<String> currencyCode;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  const AccountsCompanion({
    this.id = const Value.absent(),
    this.accountNickname = const Value.absent(),
    this.virtualBalance = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  AccountsCompanion.insert({
    this.id = const Value.absent(),
    required String accountNickname,
    this.virtualBalance = const Value.absent(),
    this.currencyCode = const Value.absent(),
    required int createdAt,
    required int updatedAt,
  }) : accountNickname = Value(accountNickname),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<AccountSettings> custom({
    Expression<int>? id,
    Expression<String>? accountNickname,
    Expression<int>? virtualBalance,
    Expression<String>? currencyCode,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountNickname != null) 'account_nickname': accountNickname,
      if (virtualBalance != null) 'virtual_balance': virtualBalance,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  AccountsCompanion copyWith({
    Value<int>? id,
    Value<String>? accountNickname,
    Value<int>? virtualBalance,
    Value<String>? currencyCode,
    Value<int>? createdAt,
    Value<int>? updatedAt,
  }) {
    return AccountsCompanion(
      id: id ?? this.id,
      accountNickname: accountNickname ?? this.accountNickname,
      virtualBalance: virtualBalance ?? this.virtualBalance,
      currencyCode: currencyCode ?? this.currencyCode,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (accountNickname.present) {
      map['account_nickname'] = Variable<String>(accountNickname.value);
    }
    if (virtualBalance.present) {
      map['virtual_balance'] = Variable<int>(virtualBalance.value);
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountsCompanion(')
          ..write('id: $id, ')
          ..write('accountNickname: $accountNickname, ')
          ..write('virtualBalance: $virtualBalance, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $MoodEntriesTable extends MoodEntries
    with TableInfo<$MoodEntriesTable, MoodEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MoodEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _moodTypeMeta = const VerificationMeta(
    'moodType',
  );
  @override
  late final GeneratedColumn<String> moodType = GeneratedColumn<String>(
    'mood_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, moodType, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mood_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<MoodEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('mood_type')) {
      context.handle(
        _moodTypeMeta,
        moodType.isAcceptableOrUnknown(data['mood_type']!, _moodTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_moodTypeMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MoodEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MoodEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      moodType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mood_type'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $MoodEntriesTable createAlias(String alias) {
    return $MoodEntriesTable(attachedDatabase, alias);
  }
}

class MoodEntry extends DataClass implements Insertable<MoodEntry> {
  final int id;
  final String moodType;
  final int createdAt;
  const MoodEntry({
    required this.id,
    required this.moodType,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['mood_type'] = Variable<String>(moodType);
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  MoodEntriesCompanion toCompanion(bool nullToAbsent) {
    return MoodEntriesCompanion(
      id: Value(id),
      moodType: Value(moodType),
      createdAt: Value(createdAt),
    );
  }

  factory MoodEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MoodEntry(
      id: serializer.fromJson<int>(json['id']),
      moodType: serializer.fromJson<String>(json['moodType']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'moodType': serializer.toJson<String>(moodType),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  MoodEntry copyWith({int? id, String? moodType, int? createdAt}) => MoodEntry(
    id: id ?? this.id,
    moodType: moodType ?? this.moodType,
    createdAt: createdAt ?? this.createdAt,
  );
  MoodEntry copyWithCompanion(MoodEntriesCompanion data) {
    return MoodEntry(
      id: data.id.present ? data.id.value : this.id,
      moodType: data.moodType.present ? data.moodType.value : this.moodType,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MoodEntry(')
          ..write('id: $id, ')
          ..write('moodType: $moodType, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, moodType, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MoodEntry &&
          other.id == this.id &&
          other.moodType == this.moodType &&
          other.createdAt == this.createdAt);
}

class MoodEntriesCompanion extends UpdateCompanion<MoodEntry> {
  final Value<int> id;
  final Value<String> moodType;
  final Value<int> createdAt;
  const MoodEntriesCompanion({
    this.id = const Value.absent(),
    this.moodType = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  MoodEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String moodType,
    required int createdAt,
  }) : moodType = Value(moodType),
       createdAt = Value(createdAt);
  static Insertable<MoodEntry> custom({
    Expression<int>? id,
    Expression<String>? moodType,
    Expression<int>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (moodType != null) 'mood_type': moodType,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  MoodEntriesCompanion copyWith({
    Value<int>? id,
    Value<String>? moodType,
    Value<int>? createdAt,
  }) {
    return MoodEntriesCompanion(
      id: id ?? this.id,
      moodType: moodType ?? this.moodType,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (moodType.present) {
      map['mood_type'] = Variable<String>(moodType.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MoodEntriesCompanion(')
          ..write('id: $id, ')
          ..write('moodType: $moodType, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $DreamItemsTable extends DreamItems
    with TableInfo<$DreamItemsTable, DreamItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DreamItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _estimatedCostMeta = const VerificationMeta(
    'estimatedCost',
  );
  @override
  late final GeneratedColumn<int> estimatedCost = GeneratedColumn<int>(
    'estimated_cost',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    description,
    estimatedCost,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dream_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<DreamItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('estimated_cost')) {
      context.handle(
        _estimatedCostMeta,
        estimatedCost.isAcceptableOrUnknown(
          data['estimated_cost']!,
          _estimatedCostMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DreamItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DreamItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      estimatedCost: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}estimated_cost'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $DreamItemsTable createAlias(String alias) {
    return $DreamItemsTable(attachedDatabase, alias);
  }
}

class DreamItem extends DataClass implements Insertable<DreamItem> {
  final int id;
  final String title;
  final String description;
  final int? estimatedCost;
  final int createdAt;
  final int updatedAt;
  const DreamItem({
    required this.id,
    required this.title,
    required this.description,
    this.estimatedCost,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    if (!nullToAbsent || estimatedCost != null) {
      map['estimated_cost'] = Variable<int>(estimatedCost);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  DreamItemsCompanion toCompanion(bool nullToAbsent) {
    return DreamItemsCompanion(
      id: Value(id),
      title: Value(title),
      description: Value(description),
      estimatedCost: estimatedCost == null && nullToAbsent
          ? const Value.absent()
          : Value(estimatedCost),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory DreamItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DreamItem(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      estimatedCost: serializer.fromJson<int?>(json['estimatedCost']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'estimatedCost': serializer.toJson<int?>(estimatedCost),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  DreamItem copyWith({
    int? id,
    String? title,
    String? description,
    Value<int?> estimatedCost = const Value.absent(),
    int? createdAt,
    int? updatedAt,
  }) => DreamItem(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    estimatedCost: estimatedCost.present
        ? estimatedCost.value
        : this.estimatedCost,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  DreamItem copyWithCompanion(DreamItemsCompanion data) {
    return DreamItem(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      estimatedCost: data.estimatedCost.present
          ? data.estimatedCost.value
          : this.estimatedCost,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DreamItem(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('estimatedCost: $estimatedCost, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, description, estimatedCost, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DreamItem &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.estimatedCost == this.estimatedCost &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DreamItemsCompanion extends UpdateCompanion<DreamItem> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> description;
  final Value<int?> estimatedCost;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  const DreamItemsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.estimatedCost = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  DreamItemsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    this.description = const Value.absent(),
    this.estimatedCost = const Value.absent(),
    required int createdAt,
    required int updatedAt,
  }) : title = Value(title),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<DreamItem> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<int>? estimatedCost,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (estimatedCost != null) 'estimated_cost': estimatedCost,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  DreamItemsCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<String>? description,
    Value<int?>? estimatedCost,
    Value<int>? createdAt,
    Value<int>? updatedAt,
  }) {
    return DreamItemsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      estimatedCost: estimatedCost ?? this.estimatedCost,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (estimatedCost.present) {
      map['estimated_cost'] = Variable<int>(estimatedCost.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DreamItemsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('estimatedCost: $estimatedCost, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $FutureLettersTable extends FutureLetters
    with TableInfo<$FutureLettersTable, FutureLetter> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FutureLettersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
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
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unlockAtMeta = const VerificationMeta(
    'unlockAt',
  );
  @override
  late final GeneratedColumn<String> unlockAt = GeneratedColumn<String>(
    'unlock_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    content,
    createdAt,
    unlockAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'future_letters';
  @override
  VerificationContext validateIntegrity(
    Insertable<FutureLetter> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
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
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('unlock_at')) {
      context.handle(
        _unlockAtMeta,
        unlockAt.isAcceptableOrUnknown(data['unlock_at']!, _unlockAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FutureLetter map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FutureLetter(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      unlockAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unlock_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $FutureLettersTable createAlias(String alias) {
    return $FutureLettersTable(attachedDatabase, alias);
  }
}

class FutureLetter extends DataClass implements Insertable<FutureLetter> {
  final int id;
  final String title;
  final String content;
  final int createdAt;
  final String? unlockAt;
  final int updatedAt;
  const FutureLetter({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    this.unlockAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['content'] = Variable<String>(content);
    map['created_at'] = Variable<int>(createdAt);
    if (!nullToAbsent || unlockAt != null) {
      map['unlock_at'] = Variable<String>(unlockAt);
    }
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  FutureLettersCompanion toCompanion(bool nullToAbsent) {
    return FutureLettersCompanion(
      id: Value(id),
      title: Value(title),
      content: Value(content),
      createdAt: Value(createdAt),
      unlockAt: unlockAt == null && nullToAbsent
          ? const Value.absent()
          : Value(unlockAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory FutureLetter.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FutureLetter(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      content: serializer.fromJson<String>(json['content']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      unlockAt: serializer.fromJson<String?>(json['unlockAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'content': serializer.toJson<String>(content),
      'createdAt': serializer.toJson<int>(createdAt),
      'unlockAt': serializer.toJson<String?>(unlockAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  FutureLetter copyWith({
    int? id,
    String? title,
    String? content,
    int? createdAt,
    Value<String?> unlockAt = const Value.absent(),
    int? updatedAt,
  }) => FutureLetter(
    id: id ?? this.id,
    title: title ?? this.title,
    content: content ?? this.content,
    createdAt: createdAt ?? this.createdAt,
    unlockAt: unlockAt.present ? unlockAt.value : this.unlockAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  FutureLetter copyWithCompanion(FutureLettersCompanion data) {
    return FutureLetter(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      content: data.content.present ? data.content.value : this.content,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      unlockAt: data.unlockAt.present ? data.unlockAt.value : this.unlockAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FutureLetter(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt, ')
          ..write('unlockAt: $unlockAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, content, createdAt, unlockAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FutureLetter &&
          other.id == this.id &&
          other.title == this.title &&
          other.content == this.content &&
          other.createdAt == this.createdAt &&
          other.unlockAt == this.unlockAt &&
          other.updatedAt == this.updatedAt);
}

class FutureLettersCompanion extends UpdateCompanion<FutureLetter> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> content;
  final Value<int> createdAt;
  final Value<String?> unlockAt;
  final Value<int> updatedAt;
  const FutureLettersCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.unlockAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  FutureLettersCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String content,
    required int createdAt,
    this.unlockAt = const Value.absent(),
    required int updatedAt,
  }) : title = Value(title),
       content = Value(content),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<FutureLetter> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? content,
    Expression<int>? createdAt,
    Expression<String>? unlockAt,
    Expression<int>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (createdAt != null) 'created_at': createdAt,
      if (unlockAt != null) 'unlock_at': unlockAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  FutureLettersCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<String>? content,
    Value<int>? createdAt,
    Value<String?>? unlockAt,
    Value<int>? updatedAt,
  }) {
    return FutureLettersCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      unlockAt: unlockAt ?? this.unlockAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (unlockAt.present) {
      map['unlock_at'] = Variable<String>(unlockAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FutureLettersCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt, ')
          ..write('unlockAt: $unlockAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AccountsTable accounts = $AccountsTable(this);
  late final $MoodEntriesTable moodEntries = $MoodEntriesTable(this);
  late final $DreamItemsTable dreamItems = $DreamItemsTable(this);
  late final $FutureLettersTable futureLetters = $FutureLettersTable(this);
  late final Index moodLatest = Index(
    'mood_latest',
    'CREATE INDEX mood_latest ON mood_entries (created_at, id)',
  );
  late final Index dreamRecent = Index(
    'dream_recent',
    'CREATE INDEX dream_recent ON dream_items (updated_at, id)',
  );
  late final Index letterRecent = Index(
    'letter_recent',
    'CREATE INDEX letter_recent ON future_letters (updated_at, id)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    accounts,
    moodEntries,
    dreamItems,
    futureLetters,
    moodLatest,
    dreamRecent,
    letterRecent,
  ];
}

typedef $$AccountsTableCreateCompanionBuilder = AccountsCompanion Function({
  Value<int> id,
  required String accountNickname,
  Value<int> virtualBalance,
  Value<String> currencyCode,
  required int createdAt,
  required int updatedAt,
});
typedef $$AccountsTableUpdateCompanionBuilder = AccountsCompanion Function({
  Value<int> id,
  Value<String> accountNickname,
  Value<int> virtualBalance,
  Value<String> currencyCode,
  Value<int> createdAt,
  Value<int> updatedAt,
});

class $$AccountsTableFilterComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountNickname => $composableBuilder(
    column: $table.accountNickname,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get virtualBalance => $composableBuilder(
    column: $table.virtualBalance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AccountsTableOrderingComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountNickname => $composableBuilder(
    column: $table.accountNickname,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get virtualBalance => $composableBuilder(
    column: $table.virtualBalance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AccountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get accountNickname => $composableBuilder(
    column: $table.accountNickname,
    builder: (column) => column,
  );

  GeneratedColumn<int> get virtualBalance => $composableBuilder(
    column: $table.virtualBalance,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AccountsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AccountsTable,
          AccountSettings,
          $$AccountsTableFilterComposer,
          $$AccountsTableOrderingComposer,
          $$AccountsTableAnnotationComposer,
          $$AccountsTableCreateCompanionBuilder,
          $$AccountsTableUpdateCompanionBuilder,
          (
            AccountSettings,
            BaseReferences<_$AppDatabase, $AccountsTable, AccountSettings>,
          ),
          AccountSettings,
          PrefetchHooks Function()
        > {
  $$AccountsTableTableManager(_$AppDatabase db, $AccountsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> accountNickname = const Value.absent(),
                Value<int> virtualBalance = const Value.absent(),
                Value<String> currencyCode = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
              }) => AccountsCompanion(
                id: id,
                accountNickname: accountNickname,
                virtualBalance: virtualBalance,
                currencyCode: currencyCode,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String accountNickname,
                Value<int> virtualBalance = const Value.absent(),
                Value<String> currencyCode = const Value.absent(),
                required int createdAt,
                required int updatedAt,
              }) => AccountsCompanion.insert(
                id: id,
                accountNickname: accountNickname,
                virtualBalance: virtualBalance,
                currencyCode: currencyCode,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AccountsTable, AccountSettings>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $AccountsTable,
                    AccountSettings
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AccountsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AccountsTable,
      AccountSettings,
      $$AccountsTableFilterComposer,
      $$AccountsTableOrderingComposer,
      $$AccountsTableAnnotationComposer,
      $$AccountsTableCreateCompanionBuilder,
      $$AccountsTableUpdateCompanionBuilder,
      (
        AccountSettings,
        BaseReferences<_$AppDatabase, $AccountsTable, AccountSettings>,
      ),
      AccountSettings,
      PrefetchHooks Function()
    >;
typedef $$MoodEntriesTableCreateCompanionBuilder =
    MoodEntriesCompanion Function({
      Value<int> id,
      required String moodType,
      required int createdAt,
    });
typedef $$MoodEntriesTableUpdateCompanionBuilder =
    MoodEntriesCompanion Function({
      Value<int> id,
      Value<String> moodType,
      Value<int> createdAt,
    });

class $$MoodEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $MoodEntriesTable> {
  $$MoodEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get moodType => $composableBuilder(
    column: $table.moodType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MoodEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $MoodEntriesTable> {
  $$MoodEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get moodType => $composableBuilder(
    column: $table.moodType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MoodEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MoodEntriesTable> {
  $$MoodEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get moodType =>
      $composableBuilder(column: $table.moodType, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$MoodEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MoodEntriesTable,
          MoodEntry,
          $$MoodEntriesTableFilterComposer,
          $$MoodEntriesTableOrderingComposer,
          $$MoodEntriesTableAnnotationComposer,
          $$MoodEntriesTableCreateCompanionBuilder,
          $$MoodEntriesTableUpdateCompanionBuilder,
          (
            MoodEntry,
            BaseReferences<_$AppDatabase, $MoodEntriesTable, MoodEntry>,
          ),
          MoodEntry,
          PrefetchHooks Function()
        > {
  $$MoodEntriesTableTableManager(_$AppDatabase db, $MoodEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MoodEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MoodEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MoodEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> moodType = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
              }) => MoodEntriesCompanion(
                id: id,
                moodType: moodType,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String moodType,
                required int createdAt,
              }) => MoodEntriesCompanion.insert(
                id: id,
                moodType: moodType,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MoodEntriesTable, MoodEntry>(table),
                  BaseReferences<_$AppDatabase, $MoodEntriesTable, MoodEntry>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MoodEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MoodEntriesTable,
      MoodEntry,
      $$MoodEntriesTableFilterComposer,
      $$MoodEntriesTableOrderingComposer,
      $$MoodEntriesTableAnnotationComposer,
      $$MoodEntriesTableCreateCompanionBuilder,
      $$MoodEntriesTableUpdateCompanionBuilder,
      (MoodEntry, BaseReferences<_$AppDatabase, $MoodEntriesTable, MoodEntry>),
      MoodEntry,
      PrefetchHooks Function()
    >;
typedef $$DreamItemsTableCreateCompanionBuilder = DreamItemsCompanion Function({
  Value<int> id,
  required String title,
  Value<String> description,
  Value<int?> estimatedCost,
  required int createdAt,
  required int updatedAt,
});
typedef $$DreamItemsTableUpdateCompanionBuilder = DreamItemsCompanion Function({
  Value<int> id,
  Value<String> title,
  Value<String> description,
  Value<int?> estimatedCost,
  Value<int> createdAt,
  Value<int> updatedAt,
});

class $$DreamItemsTableFilterComposer
    extends Composer<_$AppDatabase, $DreamItemsTable> {
  $$DreamItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get estimatedCost => $composableBuilder(
    column: $table.estimatedCost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DreamItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $DreamItemsTable> {
  $$DreamItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get estimatedCost => $composableBuilder(
    column: $table.estimatedCost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DreamItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DreamItemsTable> {
  $$DreamItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get estimatedCost => $composableBuilder(
    column: $table.estimatedCost,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$DreamItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DreamItemsTable,
          DreamItem,
          $$DreamItemsTableFilterComposer,
          $$DreamItemsTableOrderingComposer,
          $$DreamItemsTableAnnotationComposer,
          $$DreamItemsTableCreateCompanionBuilder,
          $$DreamItemsTableUpdateCompanionBuilder,
          (
            DreamItem,
            BaseReferences<_$AppDatabase, $DreamItemsTable, DreamItem>,
          ),
          DreamItem,
          PrefetchHooks Function()
        > {
  $$DreamItemsTableTableManager(_$AppDatabase db, $DreamItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DreamItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DreamItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DreamItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<int?> estimatedCost = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
              }) => DreamItemsCompanion(
                id: id,
                title: title,
                description: description,
                estimatedCost: estimatedCost,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                Value<String> description = const Value.absent(),
                Value<int?> estimatedCost = const Value.absent(),
                required int createdAt,
                required int updatedAt,
              }) => DreamItemsCompanion.insert(
                id: id,
                title: title,
                description: description,
                estimatedCost: estimatedCost,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DreamItemsTable, DreamItem>(table),
                  BaseReferences<_$AppDatabase, $DreamItemsTable, DreamItem>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DreamItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DreamItemsTable,
      DreamItem,
      $$DreamItemsTableFilterComposer,
      $$DreamItemsTableOrderingComposer,
      $$DreamItemsTableAnnotationComposer,
      $$DreamItemsTableCreateCompanionBuilder,
      $$DreamItemsTableUpdateCompanionBuilder,
      (DreamItem, BaseReferences<_$AppDatabase, $DreamItemsTable, DreamItem>),
      DreamItem,
      PrefetchHooks Function()
    >;
typedef $$FutureLettersTableCreateCompanionBuilder =
    FutureLettersCompanion Function({
      Value<int> id,
      required String title,
      required String content,
      required int createdAt,
      Value<String?> unlockAt,
      required int updatedAt,
    });
typedef $$FutureLettersTableUpdateCompanionBuilder =
    FutureLettersCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<String> content,
      Value<int> createdAt,
      Value<String?> unlockAt,
      Value<int> updatedAt,
    });

class $$FutureLettersTableFilterComposer
    extends Composer<_$AppDatabase, $FutureLettersTable> {
  $$FutureLettersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unlockAt => $composableBuilder(
    column: $table.unlockAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FutureLettersTableOrderingComposer
    extends Composer<_$AppDatabase, $FutureLettersTable> {
  $$FutureLettersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unlockAt => $composableBuilder(
    column: $table.unlockAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FutureLettersTableAnnotationComposer
    extends Composer<_$AppDatabase, $FutureLettersTable> {
  $$FutureLettersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get unlockAt =>
      $composableBuilder(column: $table.unlockAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$FutureLettersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FutureLettersTable,
          FutureLetter,
          $$FutureLettersTableFilterComposer,
          $$FutureLettersTableOrderingComposer,
          $$FutureLettersTableAnnotationComposer,
          $$FutureLettersTableCreateCompanionBuilder,
          $$FutureLettersTableUpdateCompanionBuilder,
          (
            FutureLetter,
            BaseReferences<_$AppDatabase, $FutureLettersTable, FutureLetter>,
          ),
          FutureLetter,
          PrefetchHooks Function()
        > {
  $$FutureLettersTableTableManager(_$AppDatabase db, $FutureLettersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FutureLettersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FutureLettersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FutureLettersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<String?> unlockAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
              }) => FutureLettersCompanion(
                id: id,
                title: title,
                content: content,
                createdAt: createdAt,
                unlockAt: unlockAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                required String content,
                required int createdAt,
                Value<String?> unlockAt = const Value.absent(),
                required int updatedAt,
              }) => FutureLettersCompanion.insert(
                id: id,
                title: title,
                content: content,
                createdAt: createdAt,
                unlockAt: unlockAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FutureLettersTable, FutureLetter>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $FutureLettersTable,
                    FutureLetter
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FutureLettersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FutureLettersTable,
      FutureLetter,
      $$FutureLettersTableFilterComposer,
      $$FutureLettersTableOrderingComposer,
      $$FutureLettersTableAnnotationComposer,
      $$FutureLettersTableCreateCompanionBuilder,
      $$FutureLettersTableUpdateCompanionBuilder,
      (
        FutureLetter,
        BaseReferences<_$AppDatabase, $FutureLettersTable, FutureLetter>,
      ),
      FutureLetter,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AccountsTableTableManager get accounts =>
      $$AccountsTableTableManager(_db, _db.accounts);
  $$MoodEntriesTableTableManager get moodEntries =>
      $$MoodEntriesTableTableManager(_db, _db.moodEntries);
  $$DreamItemsTableTableManager get dreamItems =>
      $$DreamItemsTableTableManager(_db, _db.dreamItems);
  $$FutureLettersTableTableManager get futureLetters =>
      $$FutureLettersTableTableManager(_db, _db.futureLetters);
}
