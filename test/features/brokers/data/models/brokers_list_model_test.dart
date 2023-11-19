import 'dart:convert';

import 'package:kilo_iot/core/domain/entity_key.dart';
import 'package:kilo_iot/features/brokers/data/models/brokers_list_model.dart';
import 'package:kilo_iot/features/brokers/domain/entities/broker_entity.dart';
import 'package:kilo_iot/features/brokers/domain/entities/brokers_list_entity.dart';
import 'package:test/test.dart';
import 'package:kilo_iot/features/brokers/data/models/broker_model.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tBrokersListModel = BrokersListModel([
    BrokerModel.withId(
      id: EntityKey(key: 'id1'),
      url: 'test_url_1',
      port: 2001,
    ),
    BrokerModel.withId(
      id: EntityKey(key: 'id2'),
      url: 'test_url_2',
      port: 2002,
    ),
    BrokerModel.withId(
      id: EntityKey(key: 'id3'),
      url: 'test_url_3',
      port: 2003,
    ),
  ]);

  test(
    'should be subclass of BrokerEntity',
    () async {
      // assert
      expect(tBrokersListModel, isA<BrokersListEntity>());
    },
  );

  group('fromJson', () {
    test(
      'should retrun a valid model when the JSON is valid',
      () async {
        // arrange
        final List<dynamic> jsonMap = json.decode(fixture('brokers_list.json'));
        // act
        final result = BrokersListModel.fromJson(jsonMap);

        // assert
        expect(result, tBrokersListModel);
      },
    );
  });

  group('toJson', () {
    test(
      'should return JSON map containing the proper data',
      () async {
        // act
        final result = tBrokersListModel.toJson();

        // assert
        final List<dynamic> jsonRaw = json.decode(fixture('brokers_list.json'));
        List<Map<String, dynamic>> expectedMap =
            jsonRaw.map((element) => element as Map<String, dynamic>).toList();
        expect(result, expectedMap);
      },
    );
  });
}
