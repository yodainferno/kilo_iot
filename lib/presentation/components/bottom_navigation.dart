import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kilo_iot/state.dart' show NavigationPagesImpl;

final navigationObject = NavigationPagesImpl();

class BottomNavigation extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = navigationObject.getProvider(ref);
    final currentPage = ref.watch(provider);


    return Scaffold(
      body: navigationObject.pages[currentPage] ?? Container(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        //
        backgroundColor: Colors.grey[900],
        selectedItemColor: Colors.limeAccent[400],
        unselectedItemColor: Colors.grey[500],

        onTap: (index) {
          ref.read(provider.notifier).state = navigationObject.pages.keys.toList()[index];
        },
        currentIndex: getCurrentPageIndex(ref),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.thermostat),
            label: 'Devices',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud),
            label: 'Brokers'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings'
          ),
        ],
      )
    );
  }

  int getCurrentPageIndex(WidgetRef ref) {
    final provider = navigationObject.getProvider(ref);
    final currentPage = ref.read(provider.notifier).state;

    return navigationObject.pages.keys.toList().indexWhere(
      (item) => item == currentPage
    );
  }
}