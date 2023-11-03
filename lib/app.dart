import 'package:flutter/material.dart';
import 'package:kilo_iot/presentation/base_styles_configuration/material_color_generator.dart';
import 'package:kilo_iot/presentation/navigation/bottom_navigation_widget.dart';
import 'package:kilo_iot/presentation/pages/brokers/brokers_add_page.dart';
import 'package:kilo_iot/presentation/pages/brokers/json_view_widget.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/brokers/new': (context) => const BrokersAddPage(),
        '/base/json_viewer': (context) => const JsonViewWidget(),
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: MaterialColorGenerator.from(
          const Color.fromARGB(255, 12, 97, 107),
        ),
        scaffoldBackgroundColor: Colors.blueGrey[50],
      ),
      home: const BottomNavigation(),
    );
  }
}
