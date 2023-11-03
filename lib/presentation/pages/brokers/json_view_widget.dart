// import 'package:flutter/material.dart';
// import 'package:flutter_json_view/flutter_json_view.dart';

// class JsonViewWidget extends StatelessWidget {
//   const JsonViewWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
//     final String data = '''{
//       "a": 123,
//       "b": 123123,
//       "d": {
//         "ooo": "hahaha",
//         "aaa": "hahaha",
//         "a2aa": "hahaha"
//       },
//       "e": [
//         1, 2, 3, 4, {
//         "ooo": "hahaha",
//         "aaa": "hahaha",
//         "a2aa": "hahaha"
//       }
//       ]
//     }''';
//     print(arguments['data']);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('New Broker'),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(
//           vertical: 30.0,
//           horizontal: 15.0,
//         ),
//         child: JsonView.string(
//           data,
//           theme: JsonViewTheme(
//             backgroundColor: Colors.white,
//             keyStyle: TextStyle(
//               color: Colors.blue[500],
//             ),
//             doubleStyle: TextStyle(
//               color: Colors.green[600],
//             ),
//             intStyle: TextStyle(
//               color: Colors.green[600],
//             ),
//             stringStyle: TextStyle(
//               color: Colors.orange[900],
//             ),
//             boolStyle: TextStyle(
//               color: Colors.blue[800],
//             ),
//             closeIcon: Icon(
//               Icons.arrow_drop_up,
//               color: Colors.grey[900],
//             ),
//             openIcon: Icon(
//               Icons.arrow_drop_down,
//               color: Colors.grey[900],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';

class JsonViewWidget extends StatelessWidget {
  const JsonViewWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final arguments = (ModalRoute.of(context)?.settings.arguments ??
    //     <String, dynamic>{}) as Map;
    final String data = '''{
      "a": 123,
      "b": 123123,
      "d": {
        "ooo": "hahaha",
        "aaa": "hahaha",
        "a2aa": "hahaha"
      }
    }'''; //arguments['data'] ?? '{}';

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
          child: JsonTreeViewNode(
            jsonData: json.decode(data),
            path: [],
          ),
        ),
      ),
    );
  }
}

final path = ["d", "aaa"];

class JsonTreeViewNode extends StatelessWidget {
  final dynamic jsonData;
  final List<String> path;

  const JsonTreeViewNode({Key? key, required this.jsonData, required this.path})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (jsonData is Map) {
      final w = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List<Widget>.from(
          jsonData.entries.map((entry) {
            // bool isOpenedKey = path.asMap()[level - 1] == entry.key;
            return IntrinsicHeight(
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // print('Key tapped: ${entry.key}');
                          print(path);
                        },
                        child: Text(
                          '${entry.key}:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                            // backgroundColor: isOpenedKey ? Colors.red[200] : null
                          ),
                        ),
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
                    padding: EdgeInsets.only(left: 10.0),
                    child: JsonTreeViewNode(
                        jsonData: entry.value, path: [...path, entry.key]),
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
          // print('Value tapped: $jsonData');
          print(path);
        },
        child: Text(
          '$jsonData',
          style: TextStyle(color: Colors.black),
        ),
      );
    }
  }
}
