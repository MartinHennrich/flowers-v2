import 'package:flutter/material.dart';

import '../../../flower.dart';
import '../../../constants/colors.dart';
import '../../../constants/enums.dart';
import '../../../utils/firebase-redux.dart';
import '../../../utils/soilMoisture.dart';

class ActionButtons extends StatelessWidget {
  final bool isLoading;
  final Flower flower;
  final Function onPress;
  final SoilMoisture soilMoisture;
  final WaterAmount waterAmount;

  ActionButtons({
    this.isLoading,
    this.flower,
    this.onPress,
    this.soilMoisture,
    this.waterAmount
  });

  Widget _getSubtitleWidget(String subtitle) {
    /* String subtitle = _getWaterSubtitleString(); */

    if (subtitle == null) {
      return Container();
    }

    return Text(subtitle,
      style: TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 14,
        color: Colors.white
      )
    );
  }

  String _getWaterSubtitleString() {
    if (soilMoisture == SoilMoisture.Soil75 || soilMoisture == SoilMoisture.Soil100) {

      if (waterAmount == WaterAmount.Lots) {
        return 'really sure?';
      }

      if (waterAmount == WaterAmount.Small) {
        return 'okey';
      }

      return 'sure?';
    }

    return null;
  }

  String _getPostponeSubtitle() {
    int days = postponeSoilMoistureToDays(soilMoisture);

    if (days <= 0) {
      return null;
    }

    if (days == 1) {
      return '$days day';
    }

    return '$days days';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 48),
      height: 80,
      color: Colors.green,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          MaterialButton(
            height: 80,
            minWidth: 120,
            color: SecondMainColor,
            disabledColor: Colors.grey,
            onPressed: isLoading ? null : () {
              onPress();
              postponeWatering(flower, soilMoisture)
                .then((_) {
                  Navigator.of(context).pop();
                });
            },
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('POSTPONE',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white
                    ),
                  ),
                  _getSubtitleWidget(_getPostponeSubtitle())
                ],
              )
          ),
          Expanded(
            child:
            MaterialButton(
              height: 80,
              color: MainSecondColor,
              disabledColor: Colors.grey,
              onPressed: isLoading ? null : () {
                onPress();
                waterFlower(flower, waterAmount, soilMoisture)
                  .then((_) {
                    Navigator.of(context).pop();
                  });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('WATER',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white
                    ),
                  ),
                  _getSubtitleWidget(_getWaterSubtitleString())
                ],
              )
            ),
          ),
        ]
      ),
    );
  }
}
