import 'package:flutter/material.dart';
import 'package:kilo_iot/presentation/base_components/information_block.dart';

class BrokersPage extends StatelessWidget {
  const BrokersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Brokers'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/brokers/new');
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: buildBody(context),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 15.0),
        child: Wrap(
          runSpacing: 20,
          children: List<Widget>.generate(
            100,
            (index) {
              return InformationBlock(
                child: Text("Block ${index + 1}"),
              );
            },
          ),
        ),
      ),
    );
  }
}
