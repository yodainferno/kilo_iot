import 'package:flutter/material.dart';
import 'package:kilo_iot/features/brokers/presentation/pages/brokers_list_page.dart';
import 'package:kilo_iot/features/devices/presentation/pages/devices_list_page.dart';
import 'package:kilo_iot/features/widgets/presentation/pages/widgets_list_page.dart';

abstract class NavigationPagesInt {
  String get initial;
  List<String> get keys;
  Widget getPage(String key);
}

class NavigationPages implements NavigationPagesInt {
  final Map<String, Widget> _pages = {
    'feed': const WidgetsListPage(),
    'devices': const DevicesListPage(),
    'brokers': const BrokersListPage()
  };

  @override
  String get initial {
    return keys[0];
  }

  @override
  List<String> get keys {
    return _pages.keys.toList();
  }

  @override
  Widget getPage(String key) {
    return _pages[key] ?? _pages[initial] ?? Container();
  }
}
