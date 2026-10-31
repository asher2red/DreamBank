import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Local-only access, deliberately separate from verified Firebase identities.
/// Restarting the app asks the user to choose a login method again.
final guestSessionProvider = NotifierProvider<GuestSession, bool>(
  GuestSession.new,
);

class GuestSession extends Notifier<bool> {
  @override
  bool build() => false;

  void start() => state = true;
  void end() => state = false;
}
