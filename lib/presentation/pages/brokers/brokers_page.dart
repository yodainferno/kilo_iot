import 'package:flutter/material.dart';
// import '../widgets/widgets.dart'; // todo

class BrokersPage extends StatelessWidget {
  const BrokersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Brokers'),
          actions: [
            IconButton(onPressed: () {
              Navigator.pushNamed(context, '/brokers/new');
            }, icon: const Icon(Icons.add))
          ],
        ),
        body: SingleChildScrollView(child: buildBody(context)));
  }

  Widget buildBody(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(children: <Widget>[
          SizedBox(height: 10),
          Text('Brokers'),
          SizedBox(height: 20),
        ]),
      ),
    );
  }
}
