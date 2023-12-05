import 'package:flutter/material.dart';
import 'package:kilo_iot/core/presentation/base_components/information_block.dart';
import 'package:kilo_iot/features/brokers/domain/entities/broker_entity.dart';
import 'package:kilo_iot/features/brokers/presentation/pages/broker_info/broker_info_page.dart';
import 'package:kilo_iot/features/brokers/presentation/pages/brokers_list/storages/brokers_list_storage.dart';
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
      appBar: AppBar(
        title: const Text('Brokers'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BrokerInfoPage(),
                ),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 30.0,
              horizontal: 15.0,
            ),
            child: Wrap(
              runSpacing: 20,
              children: [
                ...List.generate(
                  brokersList.length,
                  (index) {
                    BrokerEntity broker = brokersList[index];

                    return GestureDetector(
                      child: InformationBlock(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${broker.url}:${broker.port}",
                              style: TextStyle(
                                color: Colors.grey[900],
                                fontSize: 18.0,
                              ),
                            ),
                            const SizedBox(height: 5.0),
                            Text(
                              broker.id.key,
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 14.0,
                              ),
                            ),
                            // todo name, created
                          ],
                        ),
                      ),
                      onTap: () {
                        brokersListStorage.setCurrentBroker(broker);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BrokerInfoPage(),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
