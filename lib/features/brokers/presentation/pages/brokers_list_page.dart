import 'package:flutter/material.dart';
import 'package:kilo_iot/core/presentation/base_components/information_block.dart';
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
      appBar: AppBar(
        title: const Text('Brokers'),
        actions: [
          IconButton(
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => const BrokerInfoPage(),
              //   ),
              // );
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
                // ElevatedButton(
                //   onPressed: () {
                //     brokersListStorage.addBroker(url: 'qweqwe', port: '1883');
                //   },
                //   child: Text('add random'),
                // ),
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
                              "Broker ID: ${broker.id.key}",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            Text(
                              "URL: ${broker.url}:${broker.port}",
                              style: TextStyle(
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {},
                    );
                  },
                ),
                // ...List.generate(brokersList.length, (index) {
                //   BrokerEntity broker = brokersList[index];
                //   return Row(
                //     children: [
                //       Container(
                //         child: Text(broker.port.toString()),
                //       ),
                //       ElevatedButton(
                //         onPressed: () {
                //           brokersListStorage.deleteBroker(
                //             id: broker.id,
                //           );
                //         },
                //         child: Text('delete'),
                //       ),
                //       ElevatedButton(
                //         onPressed: () {
                //           brokersListStorage.updateBroker(
                //             id: broker.id,
                //             url: 'qweqwe',
                //             port: '8080',
                //           );
                //         },
                //         child: Text('update'),
                //       ),
                //     ],
                //   );
                // }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
