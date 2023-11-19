import 'dart:convert';

import 'package:kilo_iot/core/domain/entity_key.dart';
import 'package:kilo_iot/features/widgets/data/models/widget_model.dart';
import 'package:kilo_iot/features/widgets/domain/entities/widget_entity.dart';
import 'package:test/test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tWidgetModel = WidgetModel.withId(
    id: EntityKey(key: 'id1'),
    deviceId: EntityKey(key: 'id2'),
  );

  final tWidgetModelEmpty = WidgetModel.withId(
    id: EntityKey(key: ''),
    deviceId: EntityKey(key: ''),
  );

  test(
    'should be subclass of WidgetEntity',
    () async {
      // assert
      expect(tWidgetModel, isA<WidgetEntity>());
    },
  );

  group('fromJson', () {
    test(
      'should retrun a valid model when the JSON is valid',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('widget.json'));
        // act
        final result = WidgetModel.fromJson(jsonMap);

        // assert
        expect(result, tWidgetModel);
      },
    );

    test(
      'should retrun a valid empty model when the JSON is not valid',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('widget_empty.json'));
        // act
        final result = WidgetModel.fromJson(jsonMap);

        // assert
        expect(result, tWidgetModelEmpty);
      },
    );
  });

  group('toJson', () {
    test(
      'should return JSON map containing the proper data',
      () async {
        // act
        final result = tWidgetModel.toJson();
        // assert
        final expectedMap = {
          "id": "id1",
          "device_id": "id2"
        };
        expect(result, expectedMap);
      },
    );
  });
}
