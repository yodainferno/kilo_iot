import 'package:flutter/material.dart';
import 'package:kilo_iot/core/presentation/base_components/information_block.dart';
import 'package:kilo_iot/features/brokers/presentation/pages/broker_info/storages/broker_info_tab_state.dart';
import 'package:kilo_iot/features/brokers/presentation/pages/broker_info/widgets/form_widget.dart';
import 'package:kilo_iot/features/brokers/presentation/pages/broker_info/widgets/messages_list_widget.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class BrokerInfoPageView extends StatelessWidget {
  BrokerInfoPageView({super.key});

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

  void dispose() => tabController.dispose();

  @override
  Widget build(BuildContext context) {
    if (tabStorage == null) {
      _initTabControllerOnChanged(context);
    }
    return PageView(
      controller: tabController,
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            vertical: 30.0,
            horizontal: 15.0,
          ),
          child: InformationBlock(
            child: BrokerFormWidget(),
          ),
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