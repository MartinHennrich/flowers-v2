import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../presentation/custom_icons_icons.dart';
import '../../../constants/enums.dart';

class WaterAmountSection extends StatelessWidget {
  final void Function(WaterAmount) onPress;
  final WaterAmount waterAmount;

  WaterAmountSection({
    this.onPress,
    this.waterAmount
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 28, 0, 0),
      child: Column(
        children: <Widget>[
          Text('watering amount'),
          Container(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(CustomIcons.water_amount_small),
                  iconSize: 48,
                  color: waterAmount == WaterAmount.Small ? BlueMain : Colors.black,
                  onPressed: () {
                    onPress(WaterAmount.Small);
                  },
                ),
                IconButton(
                  icon: Icon(CustomIcons.water_amount_medium),
                  iconSize: 48,
                  color: waterAmount == WaterAmount.Normal ? BlueMain : Colors.black,
                  onPressed: () {
                    onPress(WaterAmount.Normal);
                  },
                ),
                IconButton(
                  icon: Icon(CustomIcons.water_amount_large),
                  iconSize: 40,
                  color: waterAmount == WaterAmount.Lots ? BlueMain : Colors.black,
                  onPressed: () {
                    onPress(WaterAmount.Lots);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
