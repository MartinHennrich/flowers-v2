import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../presentation/custom_icons_icons.dart';

class EmptyList extends StatelessWidget {
  final Color color;
  final IconData iconData;
  final String text;

  EmptyList({
    this.iconData,
    this.color,
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 68, 0, 68),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            iconData,
            color: color,
            size: 70,
          ),
          Padding(
            padding: EdgeInsets.only(top: 28),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(0, 0, 0, 0.3)
              ),
            )
          ),
        ],
      )
    );
  }
}
