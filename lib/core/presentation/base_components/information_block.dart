import 'package:flutter/material.dart';

class InformationBlock extends StatelessWidget {
  final Widget? child;
  InformationBlock({this.child, super.key});

  // настройки виджета
  final Color blockColor = Colors.white;
  final double rounding = 20.0;
  
  BoxShadow boxShadow = BoxShadow(
    color: Colors.grey.withOpacity(0.2),
    spreadRadius: 1,
    blurRadius: 4,
    offset: const Offset(0, 3), // changes position of shadow
  );

  EdgeInsets padding = const EdgeInsets.symmetric(
    vertical: 20.0,
    horizontal: 15.0,
  );

  //
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: blockColor,
        borderRadius: BorderRadius.all(
          Radius.circular(rounding),
        ),
        boxShadow: [boxShadow],
      ),
      padding: padding,
      child: child,
    );
  }
}
