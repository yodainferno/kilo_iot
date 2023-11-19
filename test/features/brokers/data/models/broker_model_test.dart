import 'dart:convert';

import 'package:kilo_iot/core/domain/entity_key.dart';
import 'package:kilo_iot/features/brokers/domain/entities/broker_entity.dart';
import 'package:test/test.dart';
import 'package:kilo_iot/features/brokers/data/models/broker_model.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tBrokerModel = BrokerModel.withId(
    id: EntityKey(key: 'test_key'),
    url: 'some_url',
    port: 1883,
  );

  final tBrokerModelEmpty = BrokerModel.withId(
    id: EntityKey(key: ''),
    url: '',
    port: 1883,
  );

  test(
    'should be subclass of BrokerEntity',
    () async {
      // assert
      expect(tBrokerModel, isA<BrokerEntity>());
    },
  );

  group('fromJson', () {
    test(
      'should retrun a valid model when the JSON is valid',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('broker.json'));
        // act
        final result = BrokerModel.fromJson(jsonMap);

        // assert
        expect(result, tBrokerModel);
      },
    );

    test(
      'should retrun a valid empty model when the JSON is not valid',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('broker_empty.json'));
        // act
        final result = BrokerModel.fromJson(jsonMap);

        // assert
        expect(result, tBrokerModelEmpty);
      },
    );
  });

  group('toJson', () {
    test(
      'should return JSON map containing the proper data',
      () async {
        // act
        final result = tBrokerModel.toJson();
        // assert
        final expectedMap = {
          'id': 'test_key',
          'url': 'some_url',
          'port': 1883
        };
        expect(result, expectedMap);
      },
    );
  });
}
