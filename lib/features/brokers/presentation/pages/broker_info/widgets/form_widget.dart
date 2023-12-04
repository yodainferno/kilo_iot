import 'package:flutter/material.dart';
import 'package:kilo_iot/core/presentation/base_components/input_widget.dart';
import 'package:kilo_iot/features/brokers/presentation/pages/broker_info/storages/broker_info_form_state.dart';
import 'package:provider/provider.dart';


class BrokerFormWidget extends StatelessWidget {
  BrokerFormWidget({super.key});

  final Map<String, Map<String, String?>> formFields = {
    // 'name': {'label': 'Название брокера'},
    'address': {'label': 'Адрес сервера-брокера'},
    'port': {'label': 'Порт сервера-брокера'},
  };
  
  @override
  Widget build(BuildContext context) {
    final BrokerFormStorage brokerFormStorage =
        Provider.of<BrokerFormStorage>(context, listen: true);

    return Wrap(runSpacing: 20, children: [
      ...formFields.keys.map(
        (fieldKey) {
          final String initialValue = brokerFormStorage.getFieldState(fieldKey);

          return InputWidget(
            initialValue: initialValue,
            onChanged: (String newValue) {
              brokerFormStorage.setFieldState(fieldKey, newValue);
            },
            //
            label: formFields[fieldKey]?['label'],
          );
        },
      ),
    ]);
  }
}
