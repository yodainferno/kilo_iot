import 'package:flutter/material.dart';
import 'package:kilo_iot/domain/brokers/brokers_data.dart';
import 'package:kilo_iot/presentation/base_components/information_block.dart';
import 'package:kilo_iot/presentation/pages/brokers/broker_info_page.dart';
import 'package:provider/provider.dart';

class BrokersPage extends StatefulWidget {
  const BrokersPage({super.key});

  @override
  State<BrokersPage> createState() => _BrokersPageState();
}

class _BrokersPageState extends State<BrokersPage> {
  @override
  Widget build(BuildContext context) {
    final BrokersData brokersData =
        Provider.of<BrokersData>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Brokers'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const BrokerInfoPage()));
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 30.0,
            horizontal: 15.0,
          ),
          child: Wrap(
            runSpacing: 20,
            children: brokersData.brokers.isEmpty
                ? [
                    Container(
                      alignment: Alignment.center,
                      child: const Text('Нет данных'),
                    ),
                  ]
                : List.generate(
                    brokersData.brokers.length,
                    (index) {
                      final id = brokersData.brokers.keys.toList()[index];
                      final brokerData = brokersData.brokers[id]!;

                      return GestureDetector(
                          child: InformationBlock(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  brokerData.name,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                  ),
                                ),
                                Text(
                                  "${brokerData.url}:${brokerData.port}",
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    BrokerInfoPage(brokerId: id),
                              ),
                            );
                          });
                    },
                  ),
          ),
        ),
      ),
    );
  }
}
