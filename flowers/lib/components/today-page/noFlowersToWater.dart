import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../presentation/custom_icons_icons.dart';

class NoFlowersToWater extends StatelessWidget {
  final bool hasCompleted;
  final bool hasNoFlowers;

  NoFlowersToWater({
    this.hasCompleted,
    this.hasNoFlowers
  });

  IconData _getIcon() {
    if (hasCompleted) {
      return CustomIcons.emo_thumbsup;
    }

    if (hasNoFlowers) {
      return CustomIcons.emo_displeased;
    }

    return CustomIcons.emo_grin;
  }

  String _getText() {
    if (hasCompleted) {
      return 'all flowers watered!';
    }

    if (hasNoFlowers) {
      return 'add flowers to start you journey';
    }

    return 'no flowers to water';
  }

  Color _getColor() {
    if (hasCompleted) {
      return BlueMain;
    }

    if (hasNoFlowers) {
      return YellowMain;
    }

    return GreenMain;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 68, 0, 68),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            _getIcon(),
            color: _getColor(),
            size: 70,
          ),
          Padding(
            padding: EdgeInsets.only(top: 28),
            child: Text(
              _getText(),
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
