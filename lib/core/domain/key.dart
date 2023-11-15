import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';

class Key extends Equatable {
  // state
  late final String key;

  //
  Key({required this.key});

  Key.generate() {
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