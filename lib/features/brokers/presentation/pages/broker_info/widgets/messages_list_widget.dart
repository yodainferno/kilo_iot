import 'package:flutter/material.dart';
import 'package:kilo_iot/core/presentation/base_components/information_block.dart';

class MessagesListWidget extends StatelessWidget {
  const MessagesListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 20,
      children: List.generate(
        50,
        (index) => InformationBlock(
          child: Text("index: ${index}"),
        ),
      ),
    );
  }
}