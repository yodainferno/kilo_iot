import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kilo_iot/core/domain/entity_key.dart';
import 'package:kilo_iot/core/presentation/base_components/information_block.dart';
import 'package:kilo_iot/core/presentation/json_tree/json_tree_view_store.dart';
import 'package:kilo_iot/core/presentation/json_tree/json_tree_view_widget.dart';
import 'package:kilo_iot/features/brokers/presentation/pages/broker_info/storages/messages_state.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class MessagesListWidget extends StatelessWidget {
  const MessagesListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final MessagesStorage messagesStorage =
        Provider.of<MessagesStorage>(context, listen: true);

    final messagesData = messagesStorage.messagesData;

    return SingleChildScrollView(
      child: Wrap(
        runSpacing: 20,
        children: List<Widget>.generate(
          messagesData.length,
          (index) {
            final message = messagesData[index];
            
            final MqttReceivedMessage<MqttMessage?> messageData =
                message['data'];
            final DateTime created = message['created'];
            final EntityKey id = message['id'];
            final bool isMarked = messagesStorage.marks[id] == true;

            String formattedMilliseconds =
                created.millisecond.toString().padLeft(3, '0');

            return GestureDetector(
              child: InformationBlock(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${DateFormat('HH:mm:ss').format(created)}.$formattedMilliseconds',
                            style: TextStyle(
                                color: Colors.grey[700], fontSize: 16),
                          ),
                          Text(
                            "Канал: ${messageData.topic}",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      child: Icon(
                        isMarked ? Icons.bookmark : Icons.bookmark_outline,
                        color: const Color.fromARGB(255, 12, 97, 107),
                      ),
                      onTap: () {
                        messagesStorage.setMark(id, !isMarked);
                      },
                    )
                  ],
                ),
              ),
              onTap: () {
                final recMess = messageData.payload as MqttPublishMessage;
                final jsonDataString = MqttPublishPayload.bytesToStringAsString(
                    recMess.payload.message);

                JsonTreeViewStore jsonTreeViewStore =
                    Provider.of<JsonTreeViewStore>(context, listen: false);

                Map jsonData = {};
                try {
                  jsonData = json.decode(jsonDataString);
                } catch (_) {}
                // if (jsonTreeViewStore.topic != messageData.topic) {
                  jsonTreeViewStore.jsonData = jsonData;
                  jsonTreeViewStore.topic = messageData.topic;
                //   jsonTreeViewStore.broker = {
                //     'url': formState['address'],
                //     'port': formState['port'],
                //   };
                // }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const JsonTreeViewWidget(),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
