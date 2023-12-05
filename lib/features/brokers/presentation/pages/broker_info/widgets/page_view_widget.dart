import 'package:flutter/material.dart';
import 'package:kilo_iot/core/presentation/base_components/information_block.dart';
import 'package:kilo_iot/features/brokers/presentation/pages/broker_info/storages/broker_info_tab_state.dart';
import 'package:kilo_iot/features/brokers/presentation/pages/broker_info/widgets/form_widget.dart';
import 'package:kilo_iot/features/brokers/presentation/pages/broker_info/widgets/messages_list_widget.dart';
import 'package:kilo_iot/features/brokers/presentation/pages/broker_info/widgets/mqtt_connection_indicator.dart';
import 'package:kilo_iot/features/brokers/presentation/pages/broker_info/widgets/crud_broker_widget.dart';
import 'package:provider/provider.dart';

class BrokerInfoPageView extends StatelessWidget {
  // tab controller
  TabStorage? tabStorage;
  final PageController tabController = PageController(initialPage: 0);

  void _initTabControllerOnChanged(BuildContext context) {
    tabStorage = Provider.of<TabStorage>(context, listen: false);
    tabController.addListener(
      () => {
        if (tabController.hasClients && tabController.page != null)
          {tabStorage!.tab = tabController.page!.round()}
      },
    );
  }

  void dispose() {
    return tabController.dispose();
  }

  Widget build(BuildContext context) {
    if (tabStorage == null) {
      _initTabControllerOnChanged(context);
    }
    return PageView(
      controller: tabController,
      children: [
        Stack(
          children: [
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 30.0, left: 15.0, right: 15.0, bottom: 60.0),
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          InformationBlock(
                            child: BrokerFormWidget(),
                          ),
                          const SizedBox(height: 15.0),
                          CrudWidget(),
                        ],
                      ),
                    ),
                    MqttConnectionIndicator(),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            vertical: 30.0,
            horizontal: 15.0,
          ),
          child: MessagesListWidget(),
        ),
      ],
    );
  }
}
