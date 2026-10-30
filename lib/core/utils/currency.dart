import '../errors/storage_failure.dart';
import 'input_validation.dart';

String formatWon(int value) =>
    '₩${value.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';

int parseWon(String input) {
  final value = input.trim();
  if (!RegExp(r'^(?:[0-9]+|[0-9]{1,3}(?:,[0-9]{3})+)$').hasMatch(value)) {
    throw const StorageFailure(StorageFailureKind.validation);
  }
  final amount = int.tryParse(value.replaceAll(',', ''));
  if (amount == null) throw const StorageFailure(StorageFailureKind.validation);
  validateAmount(amount);
  return amount;
}
