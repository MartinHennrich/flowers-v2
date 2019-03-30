import 'package:flutter/material.dart';

import '../../../constants/enums.dart';
import '../../../flower.dart';
import '../../../utils/firebase-redux.dart';
import '../../../utils/soilMoisture.dart';
import '../action-dialog/actionDialog.dart';
import '../action-dialog/postboneOrAction.dart';
import './soilMoistureSection.dart';
import './waterAmountSection.dart';

class WaterDialog extends StatefulWidget {
  final Flower flower;

  WaterDialog({
    this.flower
  });

  @override
  WaterDialogState createState() {
    return WaterDialogState();
  }
}

class WaterDialogState extends State<WaterDialog> {
  WaterAmount waterAmount = WaterAmount.Normal;
  SoilMoisture soilMoisture = SoilMoisture.Soil50;
  bool _isLoading = false;
  int postponeDays = 1;

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

    return '';
  }

  String _getPostponeSubtitle() {
    int days = postponeSoilMoistureToDays(soilMoisture);

    if (days <= 0) {
      return '';
    }

    if (days == 1) {
      return '$days day';
    }

    return '$days days';
  }

  @override
  Widget build(BuildContext context) {
    return ActionDialog(
      flower: widget.flower,
      customControls: Column(
        children: <Widget>[
          SoilMoistureSection(
          onPress: (type) {
            setState(() {
              this.soilMoisture = type;
            });
          },
          soilMoisture: soilMoisture,
        ),

        WaterAmountSection(
          onPress: (amount) {
            setState(() {
              this.waterAmount = amount;
            });
          },
          waterAmount: waterAmount,
        ),
        ],
      ),
      actionButtons: PostponeOrActionButtons(
        isLoading: _isLoading,
        onActionPress: () {
          setState(() {
            _isLoading = true;
          });
          waterFlower(widget.flower, waterAmount, soilMoisture)
            .then((_) {
              Navigator.of(context).pop();
            });
        },
        onPostponePress: () {
          setState(() {
            _isLoading = true;
          });
          postponeWatering(widget.flower, soilMoisture)
            .then((_) {
              Navigator.of(context).pop();
            });
        },
        postponeSubtitle: _getPostponeSubtitle(),
        postponeTitle: 'POSTPONE',
        actionSubtitle: _getWaterSubtitleString(),
        actionTitle: 'WATER',
      )
    );
  }
}
