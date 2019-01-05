import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../presentation/custom_icons_icons.dart';

class NoFlowersToWater extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 68, 0, 68),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            CustomIcons.emo_grin,
            color: SecondMainColor,
            size: 70,
          ),
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text('no flowers to water',
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
