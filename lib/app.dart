import 'package:flutter/material.dart';
import 'package:kilo_iot/features/brokers/presentation/pages/brokers_list_page.dart';
import 'package:kilo_iot/features/devices/presentation/pages/devices_list_page.dart';
import 'package:kilo_iot/features/widgets/presentation/pages/widgets_list_page.dart';
// import 'package:kilo_iot/presentation/base_styles_configuration/material_color_generator.dart';
// import 'package:kilo_iot/presentation/pages/brokers/brokers_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // debugShowCheckedModeBanner: false,
      // theme: ThemeData(
      //   primarySwatch: MaterialColorGenerator.from(
      //     const Color.fromARGB(255, 12, 97, 107),
      //   ),
      //   scaffoldBackgroundColor: Colors.blueGrey[50],
      // ),
      home: WidgetsListPage(), //DevicesListPage()//BrokersListPage(),
    );
  }
}
