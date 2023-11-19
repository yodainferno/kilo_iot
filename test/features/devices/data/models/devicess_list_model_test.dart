import 'dart:convert';

import 'package:kilo_iot/core/domain/entity_key.dart';
import 'package:kilo_iot/features/devices/data/models/device_model.dart';
import 'package:kilo_iot/features/devices/data/models/devices_list_model.dart';
import 'package:kilo_iot/features/devices/domain/entities/devices_list_entity.dart';
import 'package:test/test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tDevicesListModel = DevicesListModel([
    DeviceModel.withId(
      id: EntityKey(key: 'device_id_1'),
      brokerId: EntityKey(key: 'broker_id_1'),
      keys: const ["k1", "k2"],
      topic: "#",
    ),
    DeviceModel.withId(
      id: EntityKey(key: 'device_id_2'),
      brokerId: EntityKey(key: 'broker_id_1'),
      keys: const ["k1", "k2"],
      topic: "#",
    ),
  ]);

  test(
    'should be subclass of DevicesListEntity',
    () async {
      // assert
      expect(tDevicesListModel, isA<DevicesListEntity>());
    },
  );

  group('fromJson', () {
    test(
      'should retrun a valid model when the JSON is valid',
      () async {
        // arrange
        final List<dynamic> jsonMap = json.decode(fixture('devices_list.json'));
        // act
        final result = DevicesListModel.fromJson(jsonMap);

        // assert
        expect(result, tDevicesListModel);
      },
    );
  });

  group('toJson', () {
    test(
      'should return JSON map containing the proper data',
      () async {
        // act
        final result = tDevicesListModel.toJson();

        // assert
        final List<dynamic> jsonRaw = json.decode(fixture('devices_list.json'));
        List<Map<String, dynamic>> expectedMap =
            jsonRaw.map((element) => element as Map<String, dynamic>).toList();
        expect(result, expectedMap);
      },
    );
  });
}
