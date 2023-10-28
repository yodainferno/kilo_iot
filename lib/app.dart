import 'package:flutter/material.dart';
import 'package:kilo_iot/presentation/navigation/bottom_navigation_widget.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        canvasColor: Colors.white,
      ),
      home: const BottomNavigation(),
    );
  }
}