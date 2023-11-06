import 'dart:convert';

abstract class DeviceDataInt {
  void fromJson(String jsonString);
  String toJson();

  // bool isStateValid();
}

class DeviceData implements DeviceDataInt {
  String name = '';
  List keys = [];
  String payload = '';
  String brokerId = '';
  String topic = '';

  DeviceData({name, keys, payload, brokerId, topic}) {
    if (name != null) {
      this.name = name;
    }
    if (keys != null) {
      this.keys = keys;
    }
    if (payload != null) {
      this.payload = payload;
    }
    if (brokerId != null) {
      this.brokerId = brokerId;
    }
    if (topic != null) {
      this.topic = topic;
    }
  }

  @override
  fromJson(String jsonString) {
    try {
      final jsonData = jsonDecode(jsonString);

      final nameFromJson = jsonData['name'];
      final keysFromJson = jsonData['keys'];
      final payloadFromJson = jsonData['payload'];

      final brokerIdFromJson = jsonData['brokerId'];
      final topicFromJson = jsonData['topic'];

      name = nameFromJson;
      keys = keysFromJson;
      payload = payloadFromJson;
      brokerId = brokerIdFromJson;
      topic = topicFromJson;
    } catch (_) {
      name = '';
      keys = [];
      payload = '';
      brokerId = '';
      topic = '';
    }
  }

  @override
  String toJson() {
    final object = {
      'name': name,
      'keys': keys,
      'payload': payload,
      'brokerId': brokerId,
      'topic': topic,
    };
    return jsonEncode(object);
  }

  // @override
  // bool isStateValid() {
  //   return keys.isNotEmpty;
  // }
}
