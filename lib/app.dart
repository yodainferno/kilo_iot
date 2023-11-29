import 'package:flutter/material.dart';
import 'package:kilo_iot/core/presentation/base_styles_configuration/material_color_generator.dart';
import 'package:kilo_iot/core/presentation/navigation/bottom_navigation_widget.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: MaterialColorGenerator.from(
          const Color.fromARGB(255, 12, 97, 107),
        ),
        scaffoldBackgroundColor: Colors.blueGrey[50],
      ),
      home: const BottomNavigation()
    );
  }
}
