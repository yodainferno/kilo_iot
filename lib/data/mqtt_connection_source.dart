import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

// вернуть экземпляр работы с MQTT соединение
abstract class MQTTConnectionSourceInt {
  Future<bool> connect({
    int? ttl,
  });
  bool listenTopics({
    String? topic,
    required Function(MqttReceivedMessage<MqttMessage?> data) callBack,
  });
  bool disconect();
  bool get isConnected;
  bool get isStatusChanging;
}

class MQTTConnectionSource implements MQTTConnectionSourceInt {
  late final String address;
  late final int port;
  late final String clientId;

  MqttServerClient? client;

  MQTTConnectionSource({
    required this.address,
    int? port,
    String? clientId,
  }) {
    this.port = port ?? 1883;
    this.clientId = clientId ?? _generateClientId();
    //
    client = MqttServerClient(address, this.clientId);
    client?.port = this.port;
    //
    _printInfo("""
\n==============================
MQTT instance created with:
address: $address
port: $port
client ID: $clientId
==============================\n
""");
  }

  @override
  Future<bool> connect({
    int? ttl,
  }) async {
    assert(ttl == null || (ttl > 0));

    try {
      // попытка подключения
      await client?.connect();

      if (!isConnected) {
        throw Exception(
          "Unable to connect, status: ${client?.connectionStatus!.state}",
        );
      }
      if (ttl != null) {
        Future.delayed(Duration(seconds: ttl), () {
          disconect();
        });
      }
      return true;
    } on Exception catch (e) {
      _printInfo("Connect error: ${e.toString()}");
      return false;
    }
  }

  @override
  bool listenTopics({
    String? topic,
    required Function(MqttReceivedMessage<MqttMessage?>) callBack,
  }) {
    if (!isConnected) return false;
    topic ??= '#';

    client?.subscribe(topic, MqttQos.atMostOnce);
    _printInfo("Subscribe: $topic");
    client?.updates!.listen(
      (List<MqttReceivedMessage<MqttMessage?>>? c) {
        final data = c![0];
        callBack(data);
      },
    );
    return true;
  }

  @override
  bool disconect() {
    if (!isConnected) return false;
    client?.disconnect();
    _printInfo("Disconected");
    return true;
  }

  @override
  bool get isConnected {
    return client?.connectionStatus?.state == MqttConnectionState.connected;
  }

  @override
  bool get isStatusChanging {
    return [
      MqttConnectionState.disconnecting,
      MqttConnectionState.connecting,
    ].contains(client?.connectionStatus?.state);
  }

  _printInfo(String information) {
    const needPrint = true;
    if (needPrint) {
      print(information);
    }
  }

  _generateClientId() {
    // используем дату
    String date = DateTime.now().toIso8601String();

    // используем случайное число от 1 до 10 миллионов
    var rand = Random();
    String randHash = (pow(10, 6) + rand.nextInt(pow(10, 7).toInt())).toString();

    // конвертируем в md5
    var data = md5.convert(utf8.encode(date + randHash)).toString();
    return 'KILO-$data';
  }
}
