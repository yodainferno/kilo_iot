import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kilo_iot/presentation/base_components/information_block.dart';
import 'package:kilo_iot/presentation/base_components/input_widget.dart';
import 'package:kilo_iot/presentation/base_styles_configuration/material_color_generator.dart';
import 'package:kilo_iot/presentation/pages/json_tree_view/json_tree_view_store.dart';
import 'package:provider/provider.dart';

class JsonTreeViewWidget extends StatelessWidget {
  const JsonTreeViewWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    JsonTreeViewStore jsonTreeViewStore =
        Provider.of<JsonTreeViewStore>(context, listen: true);

    final jsonData = jsonTreeViewStore.jsonData;
    final openedKeys = jsonTreeViewStore.openedKeys;

    return Scaffold(
      appBar: AppBar(
        title: const Text('JSON Viewer'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 30.0,
            horizontal: 30.0,
          ),
          child: Column(
            children: [
              Container(
                child: InformationBlock(
                  child: Column(
                    children: [
                      JsonTreeViewNode(
                        jsonData: jsonData,
                        path: const [],
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        'Click to any value to add device keys path',
                        style:
                            TextStyle(color: Colors.grey[700], fontSize: 12.0),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              InputWidget(
                label: 'Ключи значения (разделение через "->")',
                onChanged: (value) {
                  List<String> itemsRaw = value.split('->');
                  List<String> items = List<String>.from(
                    itemsRaw.map(
                      (item) => item.trim(),
                    ),
                  );

                  if (jsonTreeViewStore.isValueExistInJsonData(items) &&
                      !listEquals(jsonTreeViewStore.path, items)) {
                    jsonTreeViewStore.path = items;
                  }
                },
                initialValue: selectedTreePathToString(jsonTreeViewStore.path),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String selectedTreePathToString(List pathData) {
    return pathData.join(' -> ');
  }
}

class JsonTreeViewNode extends StatelessWidget {
  final dynamic jsonData;
  final List path;

  const JsonTreeViewNode({
    Key? key,
    required this.jsonData,
    required this.path,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    JsonTreeViewStore jsonTreeViewStore =
        Provider.of<JsonTreeViewStore>(context, listen: false);
    bool isOpenedKey = listEquals(path, jsonTreeViewStore.path) == true;

    if (jsonData is Map) {
      final w = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List<Widget>.from(
          jsonData.entries.map((entry) {
            final currentPath = [...path, entry.key];
            final childIsNotMap = entry.value is! Map;
            final isOpened =
                childIsNotMap || jsonTreeViewStore.isOpened(currentPath);

            return IntrinsicHeight(
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${entry.key}:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: MaterialColorGenerator.from(
                              const Color.fromARGB(255, 12, 97, 107),
                            )[700]),
                      ),
                      Expanded(
                        child: Container(
                          width: 1,
                          margin: EdgeInsets.symmetric(vertical: 2.0),
                          decoration: BoxDecoration(color: Colors.grey[400]),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 2.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        childIsNotMap
                            ? Container()
                            : GestureDetector(
                                onTap: () {
                                  if (isOpened) {
                                    jsonTreeViewStore.close(currentPath);
                                  } else {
                                    jsonTreeViewStore.open(currentPath);
                                  }
                                },
                                child: Icon(
                                  isOpened
                                      ? Icons.arrow_drop_up
                                      : Icons.arrow_drop_down,
                                  size: 16,
                                ),
                              ),
                        isOpened
                            ? JsonTreeViewNode(
                                jsonData: entry.value, path: currentPath)
                            : Container(),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      );

      return Padding(
        padding: EdgeInsets.only(top: 0.0),
        child: w,
      );
    } else {
      return GestureDetector(
        onTap: () {
          jsonTreeViewStore.path = path;
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 2.0, vertical: 0.0),
          decoration: BoxDecoration(
            color: isOpenedKey
                ? MaterialColorGenerator.from(
                    const Color.fromARGB(255, 12, 97, 107),
                  )[800]
                : null,
            borderRadius: const BorderRadius.all(Radius.circular(3.0))
          ),
          child: Text(
            '$jsonData',
            style: TextStyle(
              color: isOpenedKey ? Colors.white : Colors.black,
            ),
          ),
        ),
      );
    }
  }
}
