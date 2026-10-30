import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/local_day.dart';

import 'package:go_router/go_router.dart';

class AppShell extends ConsumerWidget {
  const AppShell({required this.navigationShell, super.key});
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
    body: SafeArea(bottom: false, child: navigationShell),
    bottomNavigationBar: NavigationBar(
      selectedIndex: navigationShell.currentIndex,
      onDestinationSelected: (index) {
        ref.read(localDayProvider.notifier).refresh();
        navigationShell.goBranch(index);
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home_rounded),
          label: '홈',
        ),
        NavigationDestination(
          icon: Icon(Icons.auto_awesome_outlined),
          selectedIcon: Icon(Icons.auto_awesome),
          label: '꿈 보관함',
        ),
        NavigationDestination(
          icon: Icon(Icons.mail_outline_rounded),
          selectedIcon: Icon(Icons.mail_rounded),
          label: '미래의 편지',
        ),
        NavigationDestination(
          icon: Icon(Icons.account_balance_wallet_outlined),
          selectedIcon: Icon(Icons.account_balance_wallet),
          label: '내 계좌',
        ),
      ],
    ),
  );
}
