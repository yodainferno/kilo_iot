import 'package:flutter/material.dart';
import 'package:kilo_iot/core/domain/entity_key.dart';
import 'package:kilo_iot/features/widgets/domain/entities/widget_entity.dart';
import 'package:kilo_iot/features/widgets/presentation/storages/widgets_list_storage.dart';
import 'package:provider/provider.dart';

class WidgetsListPage extends StatefulWidget {
  const WidgetsListPage({super.key});

  @override
  State<WidgetsListPage> createState() => _WidgetsListPageState();
}

class _WidgetsListPageState extends State<WidgetsListPage> {
  @override
  Widget build(BuildContext context) {
    final WidgetsListStorage widgetsListStorage =
        Provider.of<WidgetsListStorage>(context, listen: true);

    final List<WidgetEntity> widgetsList = widgetsListStorage.widgets.widgets;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  print('aaaaaa');
                  widgetsListStorage.addWidget(
                    deviceId: EntityKey(key: 'id-123'),
                  );
                },
                child: Text('add random'),
              ),
              ...List.generate(widgetsList.length, (index) {
                WidgetEntity widget = widgetsList[index];
                return Row(
                  children: [
                    Container(
                      child: Text(
                          "${widget.id.key.toString().substring(0, 6)} - ${widget.deviceId.key.toString().substring(0, 6)}"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        widgetsListStorage.deleteWidget(
                          id: widget.id,
                        );
                      },
                      child: Text('delete'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        widgetsListStorage.updateWidget(
                          id: widget.id,
                          deviceId: EntityKey(key: 'id-4444')
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
