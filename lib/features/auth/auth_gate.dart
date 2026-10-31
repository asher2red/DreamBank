import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_service.dart';
import 'guest_session.dart';
import 'login_screen.dart';

/// Keep the account UI unmounted until authenticated or guest access is chosen.
/// Restoring a session must never briefly reveal local balances.
class AuthGate extends ConsumerWidget {
  const AuthGate({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ref.watch(guestSessionProvider)) return child;
    final profile = ref.watch(loginProfileProvider);
    if (!profile.isLoading &&
        !profile.hasError &&
        profile.asData?.value != null) {
      return child;
    }
    return const LoginScreen(startup: true);
  }
}
