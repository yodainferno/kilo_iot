import 'package:flutter/material.dart';
import 'package:kilo_iot/data/data_sources/mqtt_connection.dart';
import 'package:kilo_iot/presentation/base_components/input_widget.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:intl/intl.dart';

class BrokersAddPage extends StatefulWidget {
  const BrokersAddPage({super.key});

  @override
  BrokersAddPageState createState() => BrokersAddPageState();
}

class BrokersAddPageState extends State<BrokersAddPage> {
  final Map<String, dynamic> formState = {
    'address': 'mqtt.34devs.ru',
    'port': '1883'
  };

  final Map<String, Map<String, String?>> formFields = {
    'address': {
      'label': 'Адрес сервера-брокера'
    },
    'port': {
      'label': 'Порт сервера-брокера'
    }
  };

  MQTTConnection? mqttConnection;

  List messagesData = []; // MqttReceivedMessage<MqttMessage?>

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Broker'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 15.0),
        child: Column(
          children: [
            ...formFields.keys.map((field_key) {
              return InputWidget(
                initialValue: formState[field_key],
                onChanged: (String newValue) {
                  setState(() {
                    formState[field_key] = newValue;
                  });
                },
                //
                label: formFields[field_key]?['label'],
              );
            }),
            const SizedBox(height: 15.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size.fromHeight(40)
              ),
              onPressed: mqttConnection?.isStatusChanging == true ? null : () async{
                if (mqttConnection?.isConnected == true) {
                  mqttConnection?.disconect();
                  setState(() {});
                } else {
                  mqttConnection = MQTTConnection(
                    address: formState['address'],
                    port: int.parse(formState['port']),
                  );
                  await mqttConnection?.connect(ttl: 300);
                  mqttConnection?.listenTopics(callBack: (MqttReceivedMessage<MqttMessage?> data) {
                    setState(() {
                      messagesData.insert(0, {
                        'data': data,
                        'created': DateTime.now(),
                      });
                    });
                  });
                  messagesData = [];
                  setState(() {});
                  // mqtt.disconect();
                }
              },
              child: mqttConnection?.isStatusChanging == true
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                    )
                )
                : Text(mqttConnection?.isConnected == true ? 'Отключиться' : 'Подключиться'),
            ),
            SizedBox(height: messagesData.isNotEmpty ? 30.0 : 0.0),
            ...List<Widget>.generate(messagesData.length, (index) {

              final MqttReceivedMessage<MqttMessage?> message = messagesData[index]['data'];
              final DateTime created = messagesData[index]['created'];

              // if (index == 0) {
              //   print(messagesData[index]['data']);
              //   print(messagesData[index]['created']);
              // }
              return Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: Offset(0, 3), // changes position of shadow
                    )
                  ]
                ),
                margin: EdgeInsets.only(bottom: 30.0),
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${DateFormat('HH:mm:ss').format(created)}", style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16
                    ),),
                    Text("Topic: ${message.topic}", style: TextStyle(
                      fontSize: 16
                    ),),
                  ],
                )
              );
            }),
          ],
        ),
      ),
    );
  }

}
