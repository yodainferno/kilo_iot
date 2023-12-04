import 'package:flutter/material.dart';
import 'package:kilo_iot/core/presentation/json_tree/json_tree_view_store.dart';
import 'package:kilo_iot/core/presentation/navigation/navigation_store.dart';
import 'package:kilo_iot/features/brokers/presentation/pages/brokers_list/storages/brokers_list_storage.dart';
import 'package:kilo_iot/features/devices/presentation/storages/brokers_list_storage.dart';
import 'package:kilo_iot/features/widgets/presentation/storages/widgets_list_storage.dart';
import 'package:provider/provider.dart';
import 'app.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => BrokersListStorage(),
        ),
        ChangeNotifierProvider(
          create: (_) => DevicesListStorage(),
        ),
        ChangeNotifierProvider(
          create: (_) => WidgetsListStorage(),
        ),
        ChangeNotifierProvider(
          create: (_) => NavigationStore(),
        ),
        ChangeNotifierProvider(
          create: (_) => JsonTreeViewStore(),
        ),
      ],
      child: const App(),
    )
  );
}
