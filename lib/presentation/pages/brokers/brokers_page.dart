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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 15.0),
        child: Column(
          children: List<Widget>.generate(100, (index) {
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
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 15),
              child: Text("Block ${index + 1}"),
            );
          })
        )
      )
    );
  }
}
