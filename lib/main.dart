import 'package:flutter/material.dart';
import 'package:kilo_iot/presentation/pages/brokers/brokers_store.dart';
import 'package:provider/provider.dart';
import 'app.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => BrokersStore(),
        ),
      ],
      child: const App(),
    ),
  );
}
