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
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(children: <Widget>[
          const SizedBox(height: 10),
          const Text('Feed'),
          GestureDetector(
            child: const Text('to settings'),
            onTap: () {
              final navigationStore = Provider.of<NavigationStore>(context, listen: false);
              navigationStore.page = 'settings'; 
            },
          ),
          const SizedBox(height: 20),
          Consumer<NavigationStore>(
            builder: (context, navigationStore, _) =>Text(navigationStore.page)
          )
        ]),
      ),
    );
  }
}
