import 'package:flutter/material.dart';
import 'package:kilo_iot/domain/brokers/entities/broker_entity.dart';
import 'package:kilo_iot/presentation/pages/brokers/brokers_store.dart';
import 'package:provider/provider.dart';

class BrokersPage extends StatefulWidget {
  const BrokersPage({super.key});

  @override
  State<BrokersPage> createState() => _BrokersPageState();
}

class _BrokersPageState extends State<BrokersPage> {
  @override
  Widget build(BuildContext context) {
    final BrokersStore brokersData =
        Provider.of<BrokersStore>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Brokers'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 30.0,
            horizontal: 15.0,
          ),
          child: Column(
            children: [
              ...List.generate(
                brokersData.data.brokers.length,
                (index) {
                  final BrokerEntity broker = brokersData.data.brokers[index];
                  return GestureDetector(
                    child: Text("${broker.url}"),
                    onTap: () {
                      brokersData.deleteBroker(broker.id);
                    },
                  );
                },
              ),
              GestureDetector(
                child: Text('add'),
                onTap: () {
                  brokersData.addBroker(
                    BrokerEntity.create(
                      url: 'bad url',
                      port: 1000,
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
