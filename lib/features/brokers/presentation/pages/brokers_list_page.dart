import 'package:flutter/material.dart';
import 'package:kilo_iot/features/brokers/domain/entities/broker_entity.dart';
import 'package:kilo_iot/features/brokers/presentation/storages/brokers_list_storage.dart';
import 'package:provider/provider.dart';

class BrokersListPage extends StatefulWidget {
  const BrokersListPage({super.key});

  @override
  State<BrokersListPage> createState() => _BrokersListPageState();
}

class _BrokersListPageState extends State<BrokersListPage> {
  @override
  Widget build(BuildContext context) {
    final BrokersListStorage brokersListStorage =
        Provider.of<BrokersListStorage>(context, listen: true);

    final List<BrokerEntity> brokersList = brokersListStorage.brokers.brokers;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  brokersListStorage.addBroker(url: 'qweqwe', port: '1883');
                },
                child: Text('add random'),
              ),
              ...List.generate(brokersList.length, (index) {
                BrokerEntity broker = brokersList[index];
                return Row(
                  children: [
                    Container(
                      child: Text(broker.port.toString()),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        brokersListStorage.deleteBroker(
                          id: broker.id,
                        );
                      },
                      child: Text('delete'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        brokersListStorage.updateBroker(
                          id: broker.id,
                          url: 'qweqwe',
                          port: '8080',
                        );
                      },
                      child: Text('update'),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
