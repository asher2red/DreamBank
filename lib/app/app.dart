import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/auth/auth_gate.dart';
import 'router.dart';
import 'storage_gate.dart';
import 'local_day.dart';
import 'theme/app_theme.dart';

class DreamBankApp extends ConsumerWidget {
  const DreamBankApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => MaterialApp.router(
    title: 'DreamBank',
    builder: (context, child) => AuthGate(
      child: StorageGate(child: DayObserver(child: child!)),
    ),
    debugShowCheckedModeBanner: false,
    theme: AppTheme.dark,
    darkTheme: AppTheme.dark,
    themeMode: ThemeMode.dark,
    locale: const Locale('ko'),
    supportedLocales: const [Locale('ko')],
    localizationsDelegates: GlobalMaterialLocalizations.delegates,
    routerConfig: ref.watch(routerProvider),
  );
}
