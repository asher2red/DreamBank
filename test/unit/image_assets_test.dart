import 'dart:ui' as ui;

import 'package:dreambank/core/constants/app_assets.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('all production artwork is bundled and decodes successfully', () async {
    for (final asset in [
      AppAssets.accountBackground,
      AppAssets.homeSerenity,
      AppAssets.dreamVault,
      AppAssets.futureLetter,
    ]) {
      final data = await rootBundle.load(asset);
      final codec = await ui.instantiateImageCodec(
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
        targetWidth: 64,
      );
      final frame = await codec.getNextFrame();
      expect(frame.image.width, 64, reason: asset);
      expect(frame.image.height, greaterThan(0), reason: asset);
      frame.image.dispose();
      codec.dispose();
    }
  });
}
