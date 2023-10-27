import 'package:flutter/material.dart';
import 'package:kilo_iot/navigation_pages_state.dart';
import 'package:provider/provider.dart';
import 'app.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PagesState()),
      ],
      child: const App(),
    ),
  );
}
