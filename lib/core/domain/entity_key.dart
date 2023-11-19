import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';

class EntityKey extends Equatable {
  // state
  late final String key;

  //
  EntityKey({required this.key});

  EntityKey.generate() {
    key = md5
        .convert(
          utf8.encode(
            DateTime.now().toString(),
          ),
        )
        .toString();
  }
  @override
  List<Object?> get props => [key];
}