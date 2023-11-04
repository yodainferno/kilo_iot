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
    final NavigationStore navigationStore =
        Provider.of<NavigationStore>(context, listen: true);

    final double bottomMargin = max(
      MediaQuery.of(context).padding.bottom,
      10.0,
    );

    final double width = min(
      MediaQuery.of(context).size.width - 30 * 2,
      600,
    );

    return Scaffold(
      body: Stack(
        children: [
          navigationPages.getPage(navigationStore.page),
          Positioned(
            bottom: bottomMargin,
            left: (MediaQuery.of(context).size.width - width) / 2,
            width: width,
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: MaterialColorGenerator.from(
                        const Color.fromARGB(255, 12, 97, 107),
                      )[900]!
                          .withOpacity(0.5),
                      offset: const Offset(0, 2),
                      blurRadius: 2,
                    ),
                  ],
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  color: MaterialColorGenerator.from(
                    const Color.fromARGB(255, 12, 97, 107),
                  )[100],
                ),
                padding: const EdgeInsets.only(
                  top: 15.0,
                  bottom: 15.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List<Widget>.generate(
                    bottomNavigationItems.length,
                    ((index) {
                      bool isCurrentPage =
                          getCurrentPageIndex(navigationStore.page) == index;
                      return buildBottomNavigationButton(
                        context,
                        icon: bottomNavigationItems[index]['icon'],
                        isCurrentPage: isCurrentPage,
                        onPressed: () {
                          navigationStore.page = navigationPages.keys[index];
                        },
                      );
                    }),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  int getCurrentPageIndex(String currentPage) {
    final index = navigationPages.keys.indexWhere(
      (item) => item == currentPage,
    );
    return index < 0 ? 0 : index;
  }
}

Widget buildBottomNavigationButton(
  BuildContext context, {
  required IconData icon,
  required bool isCurrentPage,
  required Function onPressed,
}) {
  return TweenAnimationBuilder<double>(
    duration: const Duration(milliseconds: 300), // Длительность анимации
    tween: Tween<double>(
      begin: 0,
      end: isCurrentPage ? 1 : 0,
    ),
    curve: Curves.easeInOut,
    builder: (
      BuildContext context,
      double progress,
      Widget? child,
    ) {
      final Color bgBegin = MaterialColorGenerator.from(
        const Color.fromARGB(255, 12, 97, 107),
      )[100]!;
      final Color bgEnd = MaterialColorGenerator.from(
        const Color.fromARGB(255, 12, 97, 107),
      )[500]!;

      Color colorBackground = ColorTween(
        begin: bgBegin,
        end: bgEnd,
      ).lerp(progress)!;

      final Color iconBegin = MaterialColorGenerator.from(
        const Color.fromARGB(255, 12, 97, 107),
      )[700]!;
      const Color iconEnd = Colors.white;

      Color colorIcon = ColorTween(
        begin: iconBegin,
        end: iconEnd,
      ).lerp(progress)!;

      return SizedBox(
        height: 50.0,
        width: 50.0,
        child: ElevatedButton(
          style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsets>(
              const EdgeInsets.all(0.0),
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
              ),
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
