import 'dart:convert';

import 'package:kilo_iot/core/domain/entity_key.dart';
import 'package:kilo_iot/features/widgets/data/models/widgets_list_model.dart';
import 'package:kilo_iot/features/widgets/data/models/widget_model.dart';
import 'package:kilo_iot/features/widgets/domain/entities/widgets_list_entity.dart';
import 'package:test/test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tWidgetsListModel = WidgetsListModel([
    WidgetModel.withId(
      id: EntityKey(key: 'id1'),
      deviceId: EntityKey(key: 'device_id_1'),
    ),
    WidgetModel.withId(
      id: EntityKey(key: 'id2'),
      deviceId: EntityKey(key: 'device_id_1'),
    ),
  ]);

  test(
    'should be subclass of WidgetsListEntity',
    () async {
      // assert
      expect(tWidgetsListModel, isA<WidgetsListEntity>());
    },
  );

  group('fromJson', () {
    test(
      'should retrun a valid model when the JSON is valid',
      () async {
        // arrange
        final List<dynamic> jsonMap = json.decode(fixture('widgets_list.json'));
        // act
        final result = WidgetsListModel.fromJson(jsonMap);

        // assert
        expect(result, tWidgetsListModel);
      },
    );
  });

  group('toJson', () {
    test(
      'should return JSON map containing the proper data',
      () async {
        // act
        final result = tWidgetsListModel.toJson();

        // assert
        final List<dynamic> jsonRaw = json.decode(fixture('widgets_list.json'));
        List<Map<String, dynamic>> expectedMap =
            jsonRaw.map((element) => element as Map<String, dynamic>).toList();
        expect(result, expectedMap);
      },
    );
  });
}
