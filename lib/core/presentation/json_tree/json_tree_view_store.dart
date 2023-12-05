import 'package:flutter/material.dart';
import 'package:kilo_iot/core/domain/entity_key.dart';

abstract class JsonTreeViewStoreInt {
  // data
  dynamic get jsonData;
  set jsonData(dynamic newData);

  // path to seleted key
  List<String> get path;
  set path(List<String> path);

  // opened nested keys
  Map get openedKeys;
  bool isOpened(List<String> path);
  void open(List<String> path);
  void close(List<String> path);
}

class JsonTreeViewStore extends ChangeNotifier implements JsonTreeViewStoreInt {
  // data
  // state
  dynamic _jsonData = {};

  // actions
  @override
  dynamic get jsonData => _jsonData;

  @override
  set jsonData(dynamic newData) {
    _jsonData = newData;

    topic = '';
    _path = [];
    _openedKeys = {};

    inputValue = '';
    _nameOfDevice = '';

    notifyListeners();
  }

  // path to seleted key
  // state
  List<String> _path = [];
  String topic = '';
  //
  String inputValue = '';
  String _nameOfDevice = '';
  String get nameOfDevice => _nameOfDevice;
  set nameOfDevice(String value) {
    _nameOfDevice = value;
    notifyListeners();
  }

  // actions
  @override
  List<String> get path => _path;

  @override
  set path(List<String> path) {
    _path = path;
    notifyListeners();
  }

  // opened nested keys
  // state
  Map _openedKeys = {};

  // actions
  @override
  Map get openedKeys => _openedKeys;

  @override
  bool isOpened(List<String> path) {
    return _getNestedValue(_openedKeys, path) == true;
  }

  @override
  void open(List<String> path) {
    _setOpenedKeysNested(path, true);
    notifyListeners();
  }

  @override
  void close(List<String> path) {
    _setOpenedKeysNested(path, false);
    notifyListeners();
  }

  void _setOpenedKeysNested(List<String> keys, dynamic value) {
    dynamic map = _openedKeys;
    for (var i = 0; i < keys.length; i++) {
      var key = keys[i];
      if (!map.containsKey(key)) {
        map[key] = {
          'value': false,
          'children': {},
        };
      }
      if (i != keys.length - 1) {
        map = map[key]['children'];
      }
    }
    var lastKey = keys.last;
    map[lastKey]['value'] = value;
  }

  dynamic _getNestedValue(Map map, List<String> keys) {
    dynamic value = map;
    for (var key in keys) {
      if (value is Map && value.containsKey(key)) {
        if (key == keys.last) {
          value = value[key]['value'];
        } else {
          value = value[key]['children'];
        }
      } else {
        return null;
      }
    }
    return value;
  }

  bool isValueExistInJsonData(List<String> keys) {
    dynamic value = jsonData;

    for (var key in keys) {
      if (value is Map && value.containsKey(key)) {
        value = value[key];
      } else {
        return false;
      }
    }
    return value != null && value is! Map;
  }
}
