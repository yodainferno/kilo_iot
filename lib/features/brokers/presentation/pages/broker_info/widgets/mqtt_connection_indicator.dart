import 'package:flutter/material.dart';
import 'package:kilo_iot/core/domain/mqtt_data_source.dart';
import 'package:kilo_iot/core/presentation/base_styles_configuration/material_color_generator.dart';
import 'package:kilo_iot/features/brokers/presentation/pages/broker_info/storages/broker_info_form_state.dart';
import 'package:kilo_iot/features/brokers/presentation/pages/broker_info/storages/messages_state.dart';
import 'package:kilo_iot/features/brokers/presentation/pages/broker_info/storages/mqtt_connection_state.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:provider/provider.dart';

class MqttConnectionIndicator extends StatelessWidget {
  MqttConnectionIndicator({super.key});

  void onPressedAction(
      BuildContext context, MqttConnectionStorage mqttConnectionStorage) async {
    if (mqttConnectionStorage.mqttConnection?.isConnected == true) {
      mqttConnectionStorage.disconect();
    } else {
      // todo validate
      final BrokerFormStorage brokerFormStorage =
          Provider.of<BrokerFormStorage>(context, listen: false);

      mqttConnectionStorage.mqttConnection = MQTTConnection(
        address: brokerFormStorage.getFieldState('address'),
        port: brokerFormStorage.getFieldState('port').isEmpty ? 0 : int.parse(brokerFormStorage.getFieldState('port')),
      );
      await mqttConnectionStorage.connect(
        ttl: mqttConnectionStorage.defaultTTL,
      );
      mqttConnectionStorage.mqttConnection?.listenTopics(
        callBack: (MqttReceivedMessage<MqttMessage?> data) {
          final MessagesStorage messagesStorage =
              Provider.of<MessagesStorage>(context, listen: false);
          messagesStorage.addData(data);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final MqttConnectionStorage mqttConnectionStorage =
        Provider.of<MqttConnectionStorage>(context, listen: true);

    final Color button_color =
        mqttConnectionStorage.mqttConnection?.isConnected == true
            ? Colors.red[900]!
            : MaterialColorGenerator.from(
                const Color.fromARGB(255, 12, 97, 107),
              );

    Widget button_child = Container();
    if (mqttConnectionStorage.mqttConnection?.isStatusChanging == true) {
      button_child = const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 3,
        ),
      );
    } else {
      button_child = Text(
        mqttConnectionStorage.mqttConnection?.isConnected == true
            ? 'Отключиться сейчас'
            : 'Подключиться',
      );
    }

    return Column(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(40),
            backgroundColor: button_color,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
          ),
          onPressed:
              mqttConnectionStorage.mqttConnection?.isStatusChanging != true
                  ? () => onPressedAction(context, mqttConnectionStorage)
                  : null,
          child: button_child,
        ),
        const SizedBox(height: 5.0),
        Text(
          mqttConnectionStorage.mqttConnection == null ||
                  mqttConnectionStorage.mqttConnection?.isConnected != true
              ? ''
              : "До автоматического отключения: ${mqttConnectionStorage.ttlCounter} сек.",
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 14.0,
          ),
        ),
      ],
    );
  }
}
