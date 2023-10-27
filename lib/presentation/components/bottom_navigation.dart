import 'package:flutter/material.dart';
import 'package:kilo_iot/navigation_pages_state.dart';
import 'package:kilo_iot/navigation_pages.dart';
import 'package:provider/provider.dart';

final navigationPages = NavigationPages();

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final PagesState pagesState = Provider.of<PagesState>(context, listen: true);

    return Scaffold(
      body: navigationPages.getPage(pagesState.page),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        //
        backgroundColor: Colors.grey[900],
        selectedItemColor: Colors.limeAccent[400],
        unselectedItemColor: Colors.grey[500],

        onTap: (index) {
          pagesState.page = navigationPages.keys[index];
        },
        currentIndex: getCurrentPageIndex(pagesState.page),
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