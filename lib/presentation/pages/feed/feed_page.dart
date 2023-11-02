import 'package:flutter/material.dart';
import 'package:kilo_iot/presentation/navigation/navigation_store.dart';
import 'package:provider/provider.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feed')), body: buildBody(context));
  }

  Widget buildBody(BuildContext context) {
    return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 15.0),
        child: Column(
          children: List.generate(10, (index) {
            return Container(
              width: double.infinity,
            
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: Offset(0, 3), // changes position of shadow
                  )
                ]
              ),
              margin: EdgeInsets.only(bottom: 30.0),
              padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 15),
              child: Text("Block ${index + 1}"),
            );
          })
        )
    );
  }
}
