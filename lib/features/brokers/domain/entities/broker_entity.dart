import 'package:equatable/equatable.dart';
import 'package:kilo_iot/core/domain/entity_key.dart';

class BrokerEntity extends Equatable {
  late final EntityKey id;
  final String name;
  final String url;
  final int port;

  BrokerEntity.withId({
    required this.id,
    required this.name,
    required this.url,
    required this.port,
  }) {
    assert(port > 0 && port <= 65535);
    assert(name.isNotEmpty);
    assert(url.isNotEmpty);
  }

  BrokerEntity.create(
      {required this.name, required this.url, required this.port}) {
    id = EntityKey.generate();
    BrokerEntity.withId(id: id, name: name, url: url, port: port);
  }

  @override
  List<Object?> get props => [id, name, url, port];

  EntityKey? get key => null;
}
