import 'package:characters/characters.dart';

import '../errors/storage_failure.dart';

const maxVirtualAmount = 999999999999;

String validatedText(
  String value, {
  required int max,
  bool required = true,
  bool singleLine = false,
}) {
  final normalized = value.trim();
  if ((required && normalized.isEmpty) ||
      normalized.characters.length > max ||
      (singleLine && RegExp(r'[\r\n]').hasMatch(normalized))) {
    throw const StorageFailure(StorageFailureKind.validation);
  }
  return normalized;
}

void validateAmount(int value) {
  if (value < 0 || value > maxVirtualAmount) {
    throw const StorageFailure(StorageFailureKind.validation);
  }
}

int timestamp(DateTime Function() clock) {
  final value = clock().toUtc().millisecondsSinceEpoch;
  if (value < 0) throw const StorageFailure(StorageFailureKind.validation);
  return value;
}
