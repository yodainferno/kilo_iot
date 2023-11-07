
import 'package:kilo_iot/domain/base/foreign_key.dart';

// это сама дата -  entity
class BrokerEntity {
  late final ForeignKey id;
  final String url;
  final int port;

  BrokerEntity.withId({required this.id, required this.url, required this.port}) {
    assert(url.isNotEmpty);
    assert(port > 0 && port <= 65535);
  }

  BrokerEntity.create({required this.url, required this.port}) {
    id = ForeignKey.generate();
    BrokerEntity.withId(id: id, url: url, port: port);
  }
}