import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

// вернуть экземпляр работы с MQTT соединение
abstract class MQTTConnectionInt {
  Future<bool> connect({int? ttl});
  bool listenTopics({String? topic, required Function(MqttReceivedMessage<MqttMessage?> data) callBack});
  bool disconect();

}
class MQTTConnection implements MQTTConnectionInt{
  late String address;
  late int port;
  late String client_id;
  
  MqttServerClient? client;

  MQTTConnection({required this.address, port, String? client_id}) {
    this.port = port ?? 1883;
    this.client_id = client_id ?? _generateClientId();
    //
    client = MqttServerClient(address, this.client_id);
    client?.port = port;

    _printInfo("""
\n==============================
MQTT instance created with:
address: ${this.address}
port: ${this.port}
client ID: ${this.client_id}
==============================\n
""");
  }

  @override
  Future<bool> connect({int? ttl}) async {
    assert(ttl == null || (ttl > 0));

    try {
      // попытка подключения
      await client?.connect();

      if (!isConnected) {
        throw Exception("Can't to connect, status: ${client?.connectionStatus!.state}");
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
  bool listenTopics({String? topic, required Function(MqttReceivedMessage<MqttMessage?>) callBack}) {
    if (!isConnected) return false;
    topic ??= '#';
    
    client?.subscribe(topic, MqttQos.atMostOnce);
    _printInfo("Subscribe: ${topic}");
    client?.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final data = c![0];
      callBack(data);
    });
    return true;
  }

  @override
  bool disconect() {
    if (!isConnected) return false;
    client?.disconnect();
    _printInfo("Disconected");
    return true;
  }

  bool get isConnected {
    return client?.connectionStatus?.state == MqttConnectionState.connected;
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
    var rand = new Random();
    String randHash = (1000000+rand.nextInt(10000000)).toString();

    // конвертируем в md5
    var data = md5.convert(utf8.encode(date+randHash)).toString();
    return 'KILO-$data';
  }

}
