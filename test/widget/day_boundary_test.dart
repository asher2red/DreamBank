import 'package:dreambank/app/local_day.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/test_app.dart';

void main() {
  testWidgets(
    'midnight refreshes local day and observer disposal cancels its timer',
    (tester) async {
      var now = DateTime(2026, 10, 29, 23, 59, 59);
      final container = testContainer(clock: () => now);
      addTearDown(container.dispose);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const DayObserver(child: SizedBox()),
        ),
      );
      expect(container.read(localDayProvider), DateTime(2026, 10, 29));
      now = DateTime(2026, 10, 30);
      await tester.pump(const Duration(seconds: 1));
      expect(container.read(localDayProvider), DateTime(2026, 10, 30));
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );
}
