import 'package:flutter/material.dart';
import 'package:kilo_iot/presentation/base_components/information_block.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feed')),
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        vertical: 30.0,
        horizontal: 15.0,
      ),
      child: Wrap(
        runSpacing: 20,
        children: List.generate(
          10,
          (index) {
            return InformationBlock(
              child: Text(
                "Block ${index + 1}",
              ),
            );
          },
        ),
      ),
    );
  }
}
