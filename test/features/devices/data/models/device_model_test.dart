import 'dart:convert';

import 'package:kilo_iot/core/domain/entity_key.dart';
import 'package:kilo_iot/features/devices/data/models/device_model.dart';
import 'package:kilo_iot/features/devices/domain/entities/device_entity.dart';
import 'package:test/test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tDeviceModel = DeviceModel.withId(
    id: EntityKey(key: 'device_id'),
    brokerId: EntityKey(key: 'broker_id'),
    keys: const ["k1", "k2"],
    topic: "#",
  );

  final tDeviceModelEmpty = DeviceModel.withId(
    id: EntityKey(key: ''),
    brokerId: EntityKey(key: ''),
    keys: const [],
    topic: "",
  );

  test(
    'should be subclass of DeviceEntity',
    () async {
      // assert
      expect(tDeviceModel, isA<DeviceEntity>());
    },
  );

  group('fromJson', () {
    test(
      'should retrun a valid model when the JSON is valid',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('device.json'));
        // act
        final result = DeviceModel.fromJson(jsonMap);

        // assert
        expect(result, tDeviceModel);
      },
    );

    test(
      'should retrun a valid empty model when the JSON is not valid',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('device_empty.json'));
        // act
        final result = DeviceModel.fromJson(jsonMap);

        // assert
        expect(result, tDeviceModelEmpty);
      },
    );
  });

  group('toJson', () {
    test(
      'should return JSON map containing the proper data',
      () async {
        // act
        final result = tDeviceModel.toJson();
        // assert
        final expectedMap = {
          "id": "device_id",
          "broker_id": "broker_id",
          "keys": ["k1", "k2"],
          "topic": "#"
        };
        expect(result, expectedMap);
      },
    );
  });
}
