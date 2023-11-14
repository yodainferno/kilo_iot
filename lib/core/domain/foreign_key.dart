import 'dart:convert';
import 'package:crypto/crypto.dart';

class ForeignKey {
  // state
  late final String key;

  //
  ForeignKey({required this.key});

  ForeignKey.generate() {
    key = md5
        .convert(
          utf8.encode(
            DateTime.now().toString(),
          ),
        )
        .toString();
  }

  @override
  bool operator ==(Object other) {
    return other is ForeignKey && key == other.key;
  }
}