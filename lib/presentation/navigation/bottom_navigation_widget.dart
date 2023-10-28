import 'package:flutter/material.dart';
import 'package:kilo_iot/presentation/navigation/navigation_pages.dart';
import 'package:kilo_iot/presentation/navigation/navigation_store.dart';
import 'package:provider/provider.dart';

final navigationPages = NavigationPages();

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final NavigationStore navigationStore = Provider.of<NavigationStore>(context, listen: true);

    return Scaffold(
      body: navigationPages.getPage(navigationStore.page),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        //
        // backgroundColor: Color.fromARGB(255, 40, 51, 49),
        // selectedItemColor: Color.fromARGB(255, 52, 250, 207),
        // unselectedItemColor: Color.fromARGB(255, 76, 125, 114),

        onTap: (index) {
          navigationStore.page = navigationPages.keys[index];
        },
        currentIndex: getCurrentPageIndex(navigationStore.page),
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

  int getCurrentPageIndex(String currentPage) {
    final index = navigationPages.keys.indexWhere(
      (item) => item == currentPage
    );
    return index < 0 ? 0 : index;
  }
}