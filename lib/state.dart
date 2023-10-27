import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kilo_iot/presentation/feed/feed_page.dart' show FeedPage;
import 'package:kilo_iot/presentation/devices/devices_page.dart' show DevicesPage;
import 'package:kilo_iot/presentation/brokers/brokers_page.dart' show BrokersPage;
import 'package:kilo_iot/presentation/settings/settings_page.dart' show SettingsPage;


abstract class NavigationPages {
  StateProvider<String> getProvider(WidgetRef ref);
  // set page(String key);
  //
  // Widget get body;
  // List<String> get pagesKeys;
}

class NavigationPagesImpl implements NavigationPages {
  // WidgetRef ref;

  final StateProvider<String> _provider = StateProvider<String>((ref) => 'feed');
  final Map<String, Widget> pages = const {
    'feed': FeedPage(),
    'devices': DevicesPage(),
    'brokers': BrokersPage(),
    'settings': SettingsPage()
  };

  @override
  StateProvider<String> getProvider(WidgetRef ref) {
    return _provider;
  }

  // @override
  // String get page {
  //   return ref.read(provider.notifier).state; // не watch
  // }

  // @override
  // set page(String newPage) {
  //   ref.read(provider.notifier).state = newPage;
  // }

  // // @override
  // // Widget get body {
  // //   final currentPage = ref.watch(provider);
  // //   return pages[currentPage] ?? Container();
  // // }

  // @override
  // List<String> get pagesKeys {
  //   return pages.keys.toList();
  // }
}