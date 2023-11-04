import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JsonTreeStore extends ChangeNotifier {
  List _path = [];
  List get path => _path;
  set path(List path) {
    _path = path;
    notifyListeners();
  }

  Map<String, bool> _opened_pathes = {};
  bool isOpened(List path) {
    return _opened_pathes[path.join('_')] == true;
  }
  void open(List path) {
    _opened_pathes[path.join('_')] = true;
    notifyListeners();
  }

  void close(List path) {
    _opened_pathes[path.join('_')] = false;
    notifyListeners();
  }
}

class JsonViewWidget extends StatelessWidget {
  const JsonViewWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    
    var jsonData;
    try {
      throw Error();
      jsonData = json.decode(arguments['data']);
    } catch(_) {
      // jsonData = {};
      jsonData = {
        "payload": {
          "temp": {
            "value": 22.1,
            "unit": "C",
          },
          "hum": {
            "value": 780.4,
            "unit": "ммрст",
          }
        },
        "created": "2023-11-04:10:19:02"
      };
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('JSON Viewer'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 30.0,
            horizontal: 30.0,
          ),
          child: MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (_) => JsonTreeStore(),
              ),
            ],
            child: Builder(builder: (BuildContext context) {
              final JsonTreeStore jsonTreeStore =
              Provider.of<JsonTreeStore>(context, listen: true);

              // print(jsonTreeStore.path);

              return Column(children: [
                JsonTreeViewNode(
                jsonData: jsonData,
                path: [],
              ), 
              Text("PATH: ${jsonTreeStore.path}")
              ]);
            }),
          ),
        ),
      ),
    );
  }
}

class JsonTreeViewNode extends StatelessWidget {
  final dynamic jsonData;
  final List<String> path;

  const JsonTreeViewNode({Key? key, required this.jsonData, required this.path})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final JsonTreeStore jsonTreeStore =
        Provider.of<JsonTreeStore>(context, listen: true);
    bool isOpenedKey = listEquals(path, jsonTreeStore.path) == true;

    if (jsonData is Map) {
      final w = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List<Widget>.from(
          jsonData.entries.map((entry) {
            return IntrinsicHeight(
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${entry.key}:',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.blue),
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
                      GestureDetector(
                        onTap: () {
                        final path_nested = [...path, entry.key];
                        if (jsonTreeStore.isOpened(path_nested)) {
                          jsonTreeStore.close(path_nested);
                        } else {
                          jsonTreeStore.open(path_nested);
                          // print(jsonTreeStore._opened_pathes);
                          // print(jsonTreeStore.isOpened([...path, entry.key]));
                          // print([...path, entry.key]);
                        }
                      }, child: Icon(
                        jsonTreeStore.isOpened([...path, entry.key]) ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                      )),
                      jsonTreeStore.isOpened([...path, entry.key])
                        ? JsonTreeViewNode(
                            jsonData: entry.value, path: [...path, entry.key])
                        : Container(
                          child: Text('---'),
                        ),
                ])
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

      //   } else if (jsonData is List) {
      //     final w = Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: List<Widget>.from(
      //       jsonData.asMap().map((index, value) {
      //         return IntrinsicHeight(
      //           child: Row(
      //             children: [
      //               Padding(
      //                 padding: EdgeInsets.only(left: 0.0),
      //                 child: JsonTreeViewNode(
      //                   jsonData: value,
      //                   path: [...path, index]
      //                 ),
      //               ),
      //             ],
      //           ),
      //         );
      //       }),
      //     ),
      //   );

      //   return Padding(
      //     padding: EdgeInsets.only(top: 0.0),
      //     child: w,
      //   );
    } else {
      return GestureDetector(
        onTap: () {
          // Tried to listen to a value exposed with provider, from outside of the widget tree
          jsonTreeStore.path = path;
        },
        child: Text(
          '$jsonData',
          style: TextStyle(
            color: Colors.black,
            backgroundColor: isOpenedKey ? Colors.red[200] : null,
          ),
        ),
      );
    }
  }
}
