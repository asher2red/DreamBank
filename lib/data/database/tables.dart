import 'package:drift/drift.dart';

@DataClassName('AccountSettings')
class Accounts extends Table {
  @override
  String get tableName => 'account_settings';
  IntColumn get id => integer()();
  TextColumn get accountNickname => text()();
  IntColumn get virtualBalance =>
      integer().withDefault(const Constant(1000000000))();
  TextColumn get currencyCode => text().withDefault(const Constant('KRW'))();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  @override
  Set<Column> get primaryKey => {id};
  @override
  List<String> get customConstraints => [
    'CHECK (id = 1)',
    'CHECK (length(trim(account_nickname)) > 0)',
    'CHECK (virtual_balance BETWEEN 0 AND 999999999999)',
    "CHECK (currency_code = 'KRW')",
    'CHECK (created_at >= 0 AND updated_at >= 0)',
  ];
}

@TableIndex(name: 'mood_latest', columns: {#createdAt, #id})
@DataClassName('MoodEntry')
class MoodEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get moodType => text()();
  IntColumn get createdAt => integer()();
  @override
  List<String> get customConstraints => [
    "CHECK (mood_type IN ('tired', 'neutral', 'okay', 'happy'))",
    'CHECK (created_at >= 0)',
  ];
}

@TableIndex(name: 'dream_recent', columns: {#updatedAt, #id})
@DataClassName('DreamItem')
class DreamItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get description => text().withDefault(const Constant(''))();
  IntColumn get estimatedCost => integer().nullable()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  @override
  List<String> get customConstraints => [
    'CHECK (length(trim(title)) > 0)',
    'CHECK (estimated_cost IS NULL OR estimated_cost BETWEEN 0 AND 999999999999)',
    'CHECK (created_at >= 0 AND updated_at >= 0)',
  ];
}

@TableIndex(name: 'letter_recent', columns: {#updatedAt, #id})
@DataClassName('FutureLetter')
class FutureLetters extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get content => text()();
  IntColumn get createdAt => integer()();
  TextColumn get unlockAt => text().nullable()();
  IntColumn get updatedAt => integer()();
  @override
  List<String> get customConstraints => [
    'CHECK (length(trim(title)) > 0 AND length(trim(content)) > 0)',
    "CHECK (unlock_at IS NULL OR (length(unlock_at) = 10 AND unlock_at GLOB '[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]'))",
    'CHECK (created_at >= 0 AND updated_at >= 0)',
  ];
}
