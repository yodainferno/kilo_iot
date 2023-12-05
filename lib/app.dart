import 'package:flutter/material.dart';
import 'package:kilo_iot/core/helpers/mqtt_widget_connection.dart';
import 'package:kilo_iot/core/presentation/base_styles_configuration/material_color_generator.dart';
import 'package:kilo_iot/core/presentation/navigation/bottom_navigation_widget.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  App({super.key});

  bool isMqttConnectionInit = false;

  @override
  Widget build(BuildContext context) {
    if (!isMqttConnectionInit) {
      MqttWidgetConnection mqttWidgetConnection =
        Provider.of<MqttWidgetConnection>(context, listen: false);

      mqttWidgetConnection.connect();
    }
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
