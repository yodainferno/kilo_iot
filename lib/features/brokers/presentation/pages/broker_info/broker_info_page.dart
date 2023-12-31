import 'package:flutter/material.dart';
import 'package:kilo_iot/features/brokers/presentation/pages/broker_info/storages/broker_info_form_state.dart';
import 'package:kilo_iot/features/brokers/presentation/pages/broker_info/storages/broker_info_tab_state.dart';
import 'package:kilo_iot/features/brokers/presentation/pages/broker_info/storages/messages_state.dart';
import 'package:kilo_iot/features/brokers/presentation/pages/broker_info/storages/mqtt_connection_state.dart';
import 'package:kilo_iot/features/brokers/presentation/pages/broker_info/widgets/page_view_widget.dart';
import 'package:kilo_iot/features/brokers/presentation/pages/broker_info/widgets/page_indicator_widget.dart';
import 'package:kilo_iot/features/brokers/presentation/pages/brokers_list/storages/brokers_list_storage.dart';
import 'package:provider/provider.dart';

class BrokerInfoPage extends StatelessWidget {
  const BrokerInfoPage({super.key});

  // build
  @override
  Widget build(BuildContext context) {
    BrokersListStorage brokersListStorage =
        Provider.of<BrokersListStorage>(context, listen: false);
    final BrokerFormStorage brokerFormStorage =
        Provider.of<BrokerFormStorage>(context, listen: false);
    brokerFormStorage.setStateFromBroker(brokersListStorage.currentBroker);

    return MultiProvider(
      providers: [
        // ChangeNotifierProvider(
        //   create: (_) => BrokerFormStorage(brokersListStorage.currentBroker),
        // ),
        ChangeNotifierProvider(
          create: (_) => TabStorage(),
        ),
        ChangeNotifierProvider(
          create: (_) => MessagesStorage(),
        ),
        ChangeNotifierProvider(
          create: (_) => MqttConnectionStorage(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(brokersListStorage.currentBroker != null
              ? 'Брокер'
              : 'Новый брокер'),
        ),
        body: Stack(
          children: [
            BrokerInfoPageView(),
            const PageIndicatorWidget(),
          ],
        ),
      ),
    );
  }
}
