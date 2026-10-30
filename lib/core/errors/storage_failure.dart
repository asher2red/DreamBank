enum StorageFailureKind { validation, notFound, read, write, incompatible }

/// Deliberately excludes raw SQL, bound values and user text.
class StorageFailure implements Exception {
  const StorageFailure(this.kind);
  final StorageFailureKind kind;
  @override
  String toString() => 'StorageFailure(${kind.name})';
}

Future<T> storageOperation<T>(
  StorageFailureKind kind,
  Future<T> Function() work,
) async {
  try {
    return await work();
  } on StorageFailure {
    rethrow;
  } catch (_) {
    throw StorageFailure(kind);
  }
}

Stream<T> storageStream<T>(Stream<T> source) async* {
  try {
    await for (final value in source) {
      yield value;
    }
  } on StorageFailure {
    rethrow;
  } catch (_) {
    throw const StorageFailure(StorageFailureKind.read);
  }
}
