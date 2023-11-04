import 'package:flutter/material.dart';
import 'package:kilo_iot/presentation/navigation/navigation_store.dart';
import 'package:kilo_iot/presentation/pages/json_tree_view/json_tree_view_store.dart';
import 'package:provider/provider.dart';
import 'app.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => NavigationStore(),
        ),
        ChangeNotifierProvider(
          create: (_) => JsonTreeViewStore(),
        ),
      ],
      child: const App(),
    ),
  );
}
