import 'dart:convert';

abstract class BrokerDataInt {
  void fromJson(String jsonString);
  String toJson();

  bool isStateValid();
}

class BrokerData implements BrokerDataInt {
  String name = '';
  String url = '';
  int port = 0;

  BrokerData({name, url, port}) {
    if (name != null) {
      this.name = name;
    }
    if (url != null) {
      this.url = url;
    }
    if (port != null) {
      this.port = port;
    }
  }

  @override
  fromJson(String jsonString) {
    try {
      final jsonData = jsonDecode(jsonString);

      final nameFromJson = jsonData['name'];
      final urlFromJson = jsonData['url'];
      final portFromJson = jsonData['port'];

      assert(portFromJson > 0);

      name = nameFromJson;
      url = urlFromJson;
      port = portFromJson;
    } catch (_) {
      name = '';
      url = '';
      port = 0;
    }
  }

  @override
  String toJson() {
    final object = {'name': name, 'url': url, 'port': port};
    return jsonEncode(object);
  }

  @override
  bool isStateValid() {
    return url != '' && port > 0;
  }
}
