import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/storage_providers.dart';

final localDayProvider = NotifierProvider<LocalDay, DateTime>(LocalDay.new);

class LocalDay extends Notifier<DateTime> {
  @override
  DateTime build() => _date(ref.watch(clockProvider)().toLocal());
  DateTime _date(DateTime now) => DateTime(now.year, now.month, now.day);
  void refresh({bool force = false}) {
    final day = _date(ref.read(clockProvider)().toLocal());
    if (day != state) {
      state = day;
    } else if (force) {
      // Re-evaluate local timestamps after timezone/clock changes on resume.
      ref.notifyListeners();
    }
  }
}

class DayObserver extends ConsumerStatefulWidget {
  const DayObserver({required this.child, super.key});
  final Widget child;
  @override
  ConsumerState<DayObserver> createState() => _DayObserverState();
}

class _DayObserverState extends ConsumerState<DayObserver>
    with WidgetsBindingObserver {
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _schedule();
  }

  void _schedule() {
    _timer?.cancel();
    final now = ref.read(clockProvider)().toLocal();
    final next = DateTime(now.year, now.month, now.day + 1);
    _timer = Timer(next.difference(now), _refresh);
  }

  void _refresh() {
    ref.read(localDayProvider.notifier).refresh(force: true);
    _schedule();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _refresh();
  }

  @override
  void dispose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(localDayProvider);
    return widget.child;
  }
}
