import 'package:flutter/material.dart';
import 'package:kilo_iot/core/presentation/base_components/input_widget.dart';
import 'package:kilo_iot/features/devices/presentation/pages/device_info/storages/device_info_form_state.dart';
import 'package:provider/provider.dart';


class DeviceFormWidget extends StatelessWidget {
  DeviceFormWidget({super.key});

  final Map<String, Map<String, String?>> formFields = {
    // 'name': {'label': 'Название брокера'},
    'topic': {'label': 'topic'},
    'keys': {'label': 'Ключи'},
  };
  
  @override
  Widget build(BuildContext context) {
    final DeviceInfoFormStorage deviceFormStorage =
        Provider.of<DeviceInfoFormStorage>(context, listen: true);

    return Wrap(runSpacing: 20, children: [
      ...formFields.keys.map(
        (fieldKey) {
          final String initialValue = deviceFormStorage.getFieldState(fieldKey);

          return InputWidget(
            initialValue: initialValue,
            onChanged: (String newValue) {
              deviceFormStorage.setFieldState(fieldKey, newValue);
            },
            //
            label: formFields[fieldKey]?['label'],
          );
        },
      ),
    ]);
  }
}
