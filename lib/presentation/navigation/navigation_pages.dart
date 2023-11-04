import 'package:flutter/material.dart';

import 'package:kilo_iot/presentation/pages/feed/feed_page.dart';
import 'package:kilo_iot/presentation/pages/devices/devices_page.dart';
import 'package:kilo_iot/presentation/pages/brokers/brokers_page.dart';
import 'package:kilo_iot/presentation/pages/settings/settings_page.dart';

abstract class NavigationPagesInt {
  String get initial;
  List<String> get keys;
  Widget getPage(String key);
}

class NavigationPages implements NavigationPagesInt {
  final Map<String, Widget> _pages = {
    'feed': FeedPage(),
    'devices': DevicesPage(),
    'brokers': BrokersPage(),
    'settings': SettingsPage()
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
