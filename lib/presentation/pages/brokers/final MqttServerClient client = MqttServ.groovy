  final MqttServerClient client = MqttServerClient('mqtt.34devs.ru', 'client_id');
  client.port = 1883;

  try {
      // попытка подключения
      await client.connect();

      if (client.connectionStatus!.state != MqttConnectionState.connected) {
        throw Exception('123');
      }
      print('connection is successful!');
      //
      const topic = '#';
      client.subscribe(topic, MqttQos.atMostOnce);
      client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
        final data = c![0];
        print("${DateTime.now()} ${data.topic}");
        // print(data.payload);
      });
    } on Exception catch (e) {
      // ошибка подключения к брокеру

      print('connection error!');
    }
