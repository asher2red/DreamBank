import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'app_database.dart';

AppDatabase openAppDatabase() => AppDatabase(
  driftDatabase(
    name: 'dreambank',
    native: DriftNativeOptions(
      databaseDirectory: () async {
        final directory = await getApplicationSupportDirectory();
        await directory.create(recursive: true);
        return directory;
      },
    ),
  ),
);
