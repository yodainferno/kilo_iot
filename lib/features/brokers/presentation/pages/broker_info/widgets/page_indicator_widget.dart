import 'package:flutter/material.dart';
import 'package:kilo_iot/features/brokers/presentation/pages/broker_info/storages/broker_info_tab_state.dart';
import 'package:provider/provider.dart';

class PageIndicatorWidget extends StatelessWidget {
  final int totalPages = 2;
  final Color activeColor = const Color.fromARGB(255, 12, 97, 107);
  final Color inactiveColor = Colors.grey;

  const PageIndicatorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final TabStorage tabStorage =
        Provider.of<TabStorage>(context, listen: true);

    List<Widget> indicators = [];

    for (int i = 0; i < totalPages; i++) {
      indicators.add(
        Container(
          width: 10.0,
          height: 10.0,
          margin: const EdgeInsets.symmetric(horizontal: 5.0),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            color: i == tabStorage.tab ? activeColor : inactiveColor,
          ),
        ),
      );
    }

    return Align(
      alignment: Alignment.bottomCenter,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 40.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: indicators,
          ),
        ),
      ),
    );
  }
}
