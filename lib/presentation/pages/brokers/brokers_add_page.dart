import 'package:flutter/material.dart';
import 'package:kilo_iot/data/data_sources/mqtt_connection.dart';
import 'package:kilo_iot/presentation/base_components/input_widget.dart';

class BrokersAddPage extends StatefulWidget {
  const BrokersAddPage({super.key});

  @override
  BrokersAddPageState createState() => BrokersAddPageState();
}

class BrokersAddPageState extends State<BrokersAddPage> {
  final Map<String, String> formState = {
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

  final requestState = {
    'isLoading': false,
    'isError': false,
  };

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
              onPressed: requestState['isLoading'] == true ? null : () async{
                setState(() => requestState['isLoading'] = true);

                  MQTTConnection mqtt = MQTTConnection(
                    address: 'mqtt.34devs.ru',
                    port: 1883
                  );
                  await mqtt.connect(ttl: 300);
                  mqtt.listenTopics(callBack: (data) {
                    print(data.topic);
                  });
                  // mqtt.disconect();
                  

                setState(() => requestState['isLoading'] = false);
              },
              child: requestState['isLoading'] == true
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                    )
                )
                : const Text('Подключиться')
            ),
          ],
        ),
      ),
    );
  }

}
