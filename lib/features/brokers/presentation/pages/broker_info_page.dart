import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kilo_iot/core/presentation/base_components/information_block.dart';
import 'package:kilo_iot/core/presentation/base_components/input_widget.dart';
import 'package:kilo_iot/features/brokers/domain/entities/broker_entity.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BrokerInfoPage extends StatefulWidget {
  final TTL = 300;
  final String? brokerId;

  const BrokerInfoPage({this.brokerId, super.key});

  @override
  BrokerInfoPageState createState() => BrokerInfoPageState();
}

class BrokerInfoPageState extends State<BrokerInfoPage> {
  // String? brokerId;
  // BrokerEntity? brokerData;

  final Map<String, dynamic> formState = {
    'name': '',
    'address': '',
    'port': '',
  };

  final Map<String, Map<String, String?>> formFields = {
    'name': {'label': 'Название брокера'},
    'address': {'label': 'Адрес сервера-брокера'},
    'port': {'label': 'Порт сервера-брокера'},
  };

  // MQTTConnection? mqttConnection;
  // List messagesData = []; // MqttReceivedMessage<MqttMessage?>

  // Timer? _timer;
  // int _ttlCounter = 0;

  // Map<int, bool> marks = {};
  // int currentId = 1;

  // BrokerEntity brokerDataFromForm() {
  //   String name =
  //       formState['name'].isEmpty ? 'Без названия' : formState['name'];
  //   String url =
  //       formState['address'].isEmpty ? 'localhost' : formState['address'];
  //   int port = 0;
  //   try {
  //     port = int.parse(formState['port']);
  //   } catch (_) {}

  //   formState['name'] = name;
  //   formState['address'] = url;
  //   formState['port'] = port.toString();

  //   return BrokerEntity.create(url: url, port: port);
  // }

  // @override
  // void initState() {
  //   super.initState();

  //   brokerId = widget.brokerId;
  //   if (brokerId != null) {
  //     final BrokerEntity brokersData =
  //         Provider.of<BrokerEntity>(context, listen: false);

  //     brokerData = brokersData.brokers[brokerId];
  //     formState['name'] = brokerData!.name;
  //     formState['address'] = brokerData!.url;
  //     formState['port'] = brokerData!.port.toString();
  //   }
  // }

  // @override
  // void dispose() {
  //   stopTimer();
  //   super.dispose();
  // }

  PageController pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    pageController.addListener(_onPageChanged);
  }

  @override
  void dispose() {
    pageController.removeListener(_onPageChanged);
    super.dispose();
  }

  void _onPageChanged() {
    int currentPageTemp = pageController.initialPage;
    if (pageController.hasClients && pageController.page != null) {
      currentPageTemp = pageController.page!.round();
    }

    if (currentPage != currentPageTemp) {
      setState(() {
        currentPage = currentPageTemp;
      });
    }
  }

  int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    print('build build');
    // final BrokersData brokersData =
    //     Provider.of<BrokersData>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Broker'),
      ),
      body: Stack(
        children: [
          PageView(
            controller: pageController,
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  vertical: 30.0,
                  horizontal: 15.0,
                ),
                child: Wrap(
                  runSpacing: 20,
                  children: [
                    InformationBlock(
                      child: Wrap(
                        runSpacing: 20,
                        children: [
                          ...formFields.keys.map(
                            (fieldKey) {
                              return InputWidget(
                                initialValue: formState[fieldKey],
                                onChanged: (String newValue) {
                                  setState(() {
                                    formState[fieldKey] = newValue;
                                  });
                                },
                                //
                                label: formFields[fieldKey]?['label'],
                              );
                            },
                          ),
                          const SizedBox(height: 15.0),
                          // brokerId != null
                          //     ? Row(
                          //         children: [
                          //           Expanded(
                          //             child: ElevatedButton(
                          //               style: ElevatedButton.styleFrom(
                          //                 minimumSize: const Size.fromHeight(40),
                          //                 backgroundColor: MaterialColorGenerator.from(
                          //                   const Color.fromARGB(255, 12, 97, 107),
                          //                 ),
                          //                 shape: const RoundedRectangleBorder(
                          //                   borderRadius:
                          //                       BorderRadius.all(Radius.circular(10.0)),
                          //                 ),
                          //               ),
                          //               onPressed: () {
                          //                 BrokerData brokerData = brokerDataFromForm();
                          //                 brokersData.update(brokerId!, brokerData);
                          //                 this.brokerData = brokerData;
                          //               },
                          //               child: const Text('Сохранить'),
                          //             ),
                          //           ),
                          //           const SizedBox(width: 20.0),
                          //           Expanded(
                          //             child: ElevatedButton(
                          //               style: ElevatedButton.styleFrom(
                          //                 minimumSize: const Size.fromHeight(40),
                          //                 backgroundColor: Colors.red[900],
                          //                 shape: const RoundedRectangleBorder(
                          //                   borderRadius:
                          //                       BorderRadius.all(Radius.circular(10.0)),
                          //                 ),
                          //               ),
                          //               onPressed: () {
                          //                 brokersData.delete(brokerId!);
                          //                 Navigator.pop(context);
                          //               },
                          //               child: const Text('Удалить'),
                          //             ),
                          //           ),
                          //         ],
                          //       )
                          //     : ElevatedButton(
                          //         style: ElevatedButton.styleFrom(
                          //           minimumSize: const Size.fromHeight(40),
                          //           backgroundColor: MaterialColorGenerator.from(
                          //             const Color.fromARGB(255, 12, 97, 107),
                          //           ),
                          //           shape: const RoundedRectangleBorder(
                          //             borderRadius:
                          //                 BorderRadius.all(Radius.circular(10.0)),
                          //           ),
                          //         ),
                          //         onPressed: () {
                          //           BrokerData brokerData = brokerDataFromForm();
                          //           brokerId = brokersData.add(brokerDataFromForm());
                          //           this.brokerData = brokerData;
                          //         },
                          //         child: const Text('Сохранить настройки'),
                          //       ),
                          // Column(
                          //   children: [
                          //     ElevatedButton(
                          //       style: ElevatedButton.styleFrom(
                          //           minimumSize: const Size.fromHeight(40),
                          //           backgroundColor: mqttConnection?.isConnected == true
                          //               ? Colors.red[900]
                          //               : MaterialColorGenerator.from(
                          //                   const Color.fromARGB(255, 12, 97, 107),
                          //                 ),
                          //           shape: const RoundedRectangleBorder(
                          //             borderRadius:
                          //                 BorderRadius.all(Radius.circular(10.0)),
                          //           )),
                          //       onPressed: mqttConnection?.isStatusChanging == true
                          //           ? null
                          //           : () async {
                          //               if (mqttConnection?.isConnected == true) {
                          //                 mqttConnection?.disconect();
                          //                 stopTimer();
                          //                 setState(() {});
                          //               } else {
                          //                 mqttConnection = MQTTConnection(
                          //                   address: formState['address'],
                          //                   port: int.parse(formState['port']),
                          //                 );
                          //                 await mqttConnection?.connect(
                          //                     ttl: widget.TTL);
                          //                 mqttConnection?.listenTopics(
                          //                   callBack: (MqttReceivedMessage<MqttMessage?>
                          //                       data) {
                          //                     setState(
                          //                       () {
                          //                         messagesData.insert(0, {
                          //                           'id': currentId,
                          //                           'data': data,
                          //                           'created': DateTime
                          //                               .fromMillisecondsSinceEpoch(
                          //                                   DateTime.now()
                          //                                       .millisecondsSinceEpoch),
                          //                         });
                          //                         marks[currentId] = false;
                          //                         currentId++;
                          //                       },
                          //                     );
                          //                   },
                          //                 );
                          //                 startTimer();
                          //                 setState(() {});
                          //                 // mqtt.disconect();
                          //               }
                          //             },
                          //       child: mqttConnection?.isStatusChanging == true
                          //           ? const SizedBox(
                          //               width: 20,
                          //               height: 20,
                          //               child: CircularProgressIndicator(
                          //                 strokeWidth: 3,
                          //               ),
                          //             )
                          //           : Text(
                          //               mqttConnection?.isConnected == true
                          //                   ? 'Отключиться сейчас'
                          //                   : 'Подключиться',
                          //             ),
                          //     ),
                          //     mqttConnection?.isConnected == true
                          //         ? Container(
                          //             margin: const EdgeInsets.only(top: 5.0),
                          //             child: Text(
                          //               "До автоматического отключения: $_ttlCounter сек.",
                          //               style: TextStyle(
                          //                 color: Colors.grey[700],
                          //                 fontSize: 14.0,
                          //               ),
                          //             ),
                          //           )
                          //         : messagesData.isNotEmpty
                          //             ? Container(
                          //                 margin: const EdgeInsets.only(top: 5.0),
                          //                 child: ElevatedButton(
                          //                   style: ElevatedButton.styleFrom(
                          //                     minimumSize: const Size.fromHeight(40),
                          //                     backgroundColor: Colors.red[900],
                          //                     shape: const RoundedRectangleBorder(
                          //                       borderRadius: BorderRadius.all(
                          //                           Radius.circular(10.0)),
                          //                     ),
                          //                   ),
                          //                   child: Text(
                          //                       "Очистить (${messagesData.length})"),
                          //                   onPressed: () {
                          //                     setState(() {
                          //                       messagesData = [];
                          //                       marks = {};
                          //                     });
                          //                   },
                          //                 ),
                          //               )
                          //             : Container(),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                    //   SizedBox(height: messagesData.isNotEmpty ? 30.0 : 0.0),
                    //   ...List<Widget>.generate(
                    //     messagesData.length,
                    //     (index) {
                    //       final MqttReceivedMessage<MqttMessage?> messageData =
                    //           messagesData[index]['data'];
                    //       final DateTime created = messagesData[index]['created'];
                    //       final int id = messagesData[index]['id'];
                    //       final bool isMarked = marks[id] == true;

                    //       String formattedMilliseconds =
                    //           created.millisecond.toString().padLeft(3, '0');

                    //       return GestureDetector(
                    //         child: InformationBlock(
                    //           child: Row(
                    //             children: [
                    //               Expanded(
                    //                 child: Column(
                    //                   crossAxisAlignment: CrossAxisAlignment.start,
                    //                   children: [
                    //                     Text(
                    //                       '${DateFormat('HH:mm:ss').format(created)}.$formattedMilliseconds',
                    //                       style: TextStyle(
                    //                           color: Colors.grey[700], fontSize: 16),
                    //                     ),
                    //                     Text(
                    //                       "Topic: ${messageData.topic}",
                    //                       style: const TextStyle(fontSize: 16),
                    //                     ),
                    //                   ],
                    //                 ),
                    //               ),
                    //               GestureDetector(
                    //                 child: Icon(
                    //                   isMarked ? Icons.bookmark : Icons.bookmark_outline,
                    //                   color: const Color.fromARGB(255, 12, 97, 107),
                    //                 ),
                    //                 onTap: () {
                    //                   setState(() {
                    //                     marks[id] = !isMarked;
                    //                   });
                    //                 },
                    //               )
                    //             ],
                    //           ),
                    //         ),
                    //         onTap: () {
                    //           final recMess = messageData.payload as MqttPublishMessage;
                    //           final jsonDataString =
                    //               MqttPublishPayload.bytesToStringAsString(
                    //                   recMess.payload.message);

                    //           JsonTreeViewStore jsonTreeViewStore =
                    //               Provider.of<JsonTreeViewStore>(context, listen: false);

                    //           Map jsonData = {};
                    //           try {
                    //             jsonData = json.decode(jsonDataString);
                    //           } catch (_) {}
                    //           if (jsonTreeViewStore.topic != messageData.topic) {
                    //             jsonTreeViewStore.jsonData = jsonData;
                    //             jsonTreeViewStore.topic = messageData.topic;
                    //             jsonTreeViewStore.broker = {
                    //               'url': formState['address'],
                    //               'port': formState['port'],
                    //             };
                    //           }

                    //           Navigator.push(
                    //               context,
                    //               MaterialPageRoute(
                    //                   builder: (context) => const JsonTreeViewWidget()));
                    //         },
                    //       );
                    //     },
                    //   ),
                  ],
                ),
              ),
              SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    vertical: 30.0,
                    horizontal: 15.0,
                  ),
                  child: Wrap(
                      runSpacing: 20,
                      children: List.generate(
                          50,
                          (index) => InformationBlock(
                              child: Text("index: ${index}")))))
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40.0,
                ),
                child: PageIndicatorWidget(
                  currentPage: currentPage,
                  totalPages: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // void startTimer() {
  //   _ttlCounter = widget.TTL;
  //   const oneSec = Duration(seconds: 1);
  //   _timer = Timer.periodic(
  //     oneSec,
  //     (Timer timer) {
  //       setState(() {
  //         if (_ttlCounter <= 0) {
  //           timer.cancel();
  //         } else {
  //           _ttlCounter--;
  //         }
  //       });
  //     },
  //   );
  // }

  // void stopTimer() {
  //   if (_timer != null) {
  //     _timer!.cancel();
  //   }
  // }
}

class PageIndicatorWidget extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  final Color activeColor;
  final Color inactiveColor;

  const PageIndicatorWidget({
    super.key,
    required this.currentPage,
    required this.totalPages,
    this.activeColor = const Color.fromARGB(255, 12, 97, 107),
    this.inactiveColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> indicators = [];
    for (int i = 0; i < totalPages; i++) {
      indicators.add(
        Container(
          width: 10.0,
          height: 10.0,
          margin: const EdgeInsets.symmetric(horizontal: 5.0),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            color: i == currentPage ? activeColor : inactiveColor,
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: indicators,
    );
  }
}
