import 'package:flutter/material.dart';
import 'package:kilo_iot/core/helpers/mqtt_widget_connection.dart';
import 'package:kilo_iot/core/presentation/json_tree/json_tree_view_store.dart';
import 'package:kilo_iot/core/presentation/navigation/navigation_store.dart';
import 'package:kilo_iot/features/brokers/presentation/pages/broker_info/storages/broker_info_form_state.dart';
import 'package:kilo_iot/features/brokers/presentation/pages/brokers_list/storages/brokers_list_storage.dart';
import 'package:kilo_iot/features/devices/presentation/pages/devices_list/storages/brokers_list_storage.dart';
import 'package:kilo_iot/features/widgets/presentation/storages/widgets_list_storage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';

// debug
clearStorage() async {
  final Map<String, bool> clearList = {
    'brokers': false,
    'devices': false,
    'widgets': false
  };

  final sharedPreferences = await SharedPreferences.getInstance();
  for (String key in clearList.keys.toList()) {
    if (clearList[key]!) {
      sharedPreferences.setString(key, '[]');
    }
  }
}

void main() async {
  //
  runApp(MultiProvider(
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
      ChangeNotifierProvider(
        create: (_) => MqttWidgetConnection(),
      ),
        ChangeNotifierProvider(
          create: (_) => BrokerFormStorage(),
        ),
    ],
    child: App(),
  ));

  clearStorage(); // debug
}
