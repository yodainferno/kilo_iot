import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kilo_iot/presentation/base_styles_configuration/material_color_generator.dart';
import 'package:kilo_iot/presentation/navigation/navigation_pages.dart';
import 'package:kilo_iot/presentation/navigation/navigation_store.dart';
import 'package:provider/provider.dart';

final navigationPages = NavigationPages();

const List<Map> bottomNavigationItems = [
  {
    'label': 'Feed',
    'icon': Icons.home,
  },
  {
    'label': 'Devices',
    'icon': Icons.thermostat,
  },
  {
    'label': 'Brokers',
    'icon': Icons.cloud,
  },
  {
    'label': 'Settings',
    'icon': Icons.settings,
  },
];

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({super.key});
  
  @override
  Widget build(BuildContext context) {
    final NavigationStore navigationStore = Provider.of<NavigationStore>(context, listen: true);

    return Scaffold(
      body: Stack(
      children: [
        navigationPages.getPage(navigationStore.page),
        Positioned(
          bottom: max(MediaQuery.of(context).padding.bottom, 10.0),
          left: MediaQuery.of(context).size.width / 2 - min(MediaQuery.of(context).size.width - 30*2, 600) / 2,
          width: min(MediaQuery.of(context).size.width - 30*2, 600),
          child: Center(
            child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: MaterialColorGenerator.from(Color.fromARGB(255, 12, 97, 107))[900]!.withOpacity(0.5),
                  offset: const Offset(0, 2),
                  blurRadius: 2,
                ),
              ],
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: MaterialColorGenerator.from(Color.fromARGB(255, 12, 97, 107))[100],
            ),
            padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List<Widget>.generate(bottomNavigationItems.length, ((index) {
                  bool isCurrentPage = getCurrentPageIndex(navigationStore.page) == index;
                  return buildBottomNavigationButton(
                    context,
                    icon: bottomNavigationItems[index]['icon'],
                    isCurrentPage: isCurrentPage,
                    onPressed: () {
                      // print(navigationStore.page);
                      navigationStore.page = navigationPages.keys[index];
                    },
                  );
                }))
              )
            )
          )
        )

        ]
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


Widget buildBottomNavigationButton(BuildContext context, {
  required IconData icon,
  required bool isCurrentPage,
  required Function onPressed,
}) {
  return TweenAnimationBuilder<double>(
    duration: Duration(milliseconds: 300), // Длительность анимации
    tween: Tween<double>(begin: 0, end: isCurrentPage ? 1 : 0), // Интерполяция цвета
    curve: Curves.easeInOut,
    builder: (BuildContext context, double progress, Widget? child) {

    Color colorBackground = ColorTween(begin: MaterialColorGenerator.from(Color.fromARGB(255, 12, 97, 107))[100], end: MaterialColorGenerator.from(Color.fromARGB(255, 12, 97, 107))[500]).lerp(progress)!;
    Color colorIcon = ColorTween(begin: MaterialColorGenerator.from(Color.fromARGB(255, 12, 97, 107))[700], end: Colors.white).lerp(progress)!;

      return SizedBox(
        height: 50.0,
        width: 50.0,
        child: ElevatedButton(
          style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsets>(
              EdgeInsets.all(0.0),
            ),
            overlayColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                return Colors.transparent;
              },
            ),
            elevation: MaterialStateProperty.all(0),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              )
            ),
            backgroundColor: MaterialStateProperty.all(colorBackground),
          ),
          child: Icon(
            icon,
            color: colorIcon,
          ),
          onPressed: () {
            onPressed();
          },
        ),
      );
    },
  );
}