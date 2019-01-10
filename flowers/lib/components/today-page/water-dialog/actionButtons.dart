import 'package:flutter/material.dart';

import '../../../flower.dart';
import '../../../constants/colors.dart';
import '../../../constants/enums.dart';
import '../../../utils/firebase-redux.dart';
import '../../../utils/soilMoisture.dart';
import '../../gradientMaterialButton.dart';

class ActionButtons extends StatefulWidget {
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

  @override
    State<StatefulWidget> createState() {
      return ActionButtonsState();
    }
}

enum ButtonAction {
  Water,
  Postpone
}

class ActionButtonsState extends State<ActionButtons> {
  ButtonAction buttonAction;

  Widget _getSubtitleWidget(String subtitle) {
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
    if (widget.soilMoisture == SoilMoisture.Soil75 || widget.soilMoisture == SoilMoisture.Soil100) {

      if (widget.waterAmount == WaterAmount.Lots) {
        return 'really sure?';
      }

      if (widget.waterAmount == WaterAmount.Small) {
        return 'okey';
      }

      return 'sure?';
    }

    return null;
  }

  String _getPostponeSubtitle() {
    int days = postponeSoilMoistureToDays(widget.soilMoisture);

    if (days <= 0) {
      return null;
    }

    if (days == 1) {
      return '$days day';
    }

    return '$days days';
  }

  Widget getPostponeButtonChild() {
    if (buttonAction != ButtonAction.Postpone) {
      return Column(
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
      );
    }

    return CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
    );
  }

  Widget getWaterButtonChild() {
    if (buttonAction != ButtonAction.Water) {
      return Column(
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
      );
    }
    return CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
    );
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
          GradientButton(
            height: 80,
            width: 120,
            gradient: buttonAction == ButtonAction.Water ? GreyGradient : YellowGradient,
            onPressed: widget.isLoading ? null : () {
              setState(() {
                buttonAction = ButtonAction.Postpone;
              });
              widget.onPress();
              postponeWatering(widget.flower, widget.soilMoisture)
                .then((_) {
                  Navigator.of(context).pop();
                });
            },
            child: getPostponeButtonChild()
          ),
          Expanded(
            child: GradientButton(
              height: 80,
              gradient: buttonAction == ButtonAction.Postpone ? GreyGradient : BlueGradient,
              onPressed: widget.isLoading ? null : () {
                setState(() {
                  buttonAction = ButtonAction.Water;
                });
                widget.onPress();
                waterFlower(widget.flower, widget.waterAmount, widget.soilMoisture)
                  .then((_) {
                    Navigator.of(context).pop();
                  });
              },
              child: getWaterButtonChild(),
            ),
          ),
        ]
      ),
    );
  }
}
