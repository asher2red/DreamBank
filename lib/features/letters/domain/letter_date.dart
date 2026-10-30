import '../../../core/errors/storage_failure.dart';

/// A calendar date, never converted to a UTC instant.
class LetterDate implements Comparable<LetterDate> {
  const LetterDate._(this.value);
  final String value;

  factory LetterDate.parse(String value) {
    if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value)) {
      throw const StorageFailure(StorageFailureKind.validation);
    }
    final year = int.parse(value.substring(0, 4));
    final month = int.parse(value.substring(5, 7));
    final day = int.parse(value.substring(8, 10));
    final date = DateTime.utc(year, month, day);
    if (year < 1 ||
        date.year != year ||
        date.month != month ||
        date.day != day) {
      throw const StorageFailure(StorageFailureKind.validation);
    }
    return LetterDate._(value);
  }

  factory LetterDate.fromLocal(DateTime local) => LetterDate.parse(
    '${local.year.toString().padLeft(4, '0')}-${local.month.toString().padLeft(2, '0')}-${local.day.toString().padLeft(2, '0')}',
  );

  @override
  int compareTo(LetterDate other) => value.compareTo(other.value);
}

bool canOpenLetter(String? unlockAt, DateTime now) =>
    unlockAt == null ||
    LetterDate.fromLocal(now.toLocal()).compareTo(LetterDate.parse(unlockAt)) >=
        0;
