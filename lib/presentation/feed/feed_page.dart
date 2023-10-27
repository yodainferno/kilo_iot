import 'package:flutter/material.dart';
// import '../widgets/widgets.dart'; // todo
class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Feed')),
        body: buildBody(context)
      );
  }

  Widget buildBody(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(children: <Widget>[
          SizedBox(height: 10),
          Text('Feed'),
          SizedBox(height: 20),
        ]),
      ),
    );
  }
}
