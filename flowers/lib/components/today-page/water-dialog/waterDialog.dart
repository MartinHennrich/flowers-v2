import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../flower.dart';
import '../../../constants/enums.dart';
import './soilMoistureSection.dart';
import './waterAmountSection.dart';
import './actionButtons.dart';

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

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: EdgeInsets.all(0),
      children: <Widget>[
        Stack(
          children: <Widget>[
            Center(
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 16, 0, 8),
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(widget.flower.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 8,
              top: 8,
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.close, size: 28, color: Colors.grey)
              ),
            ),
          ],
        ),

        Center(
          child: Container(
            child: Text(widget.flower.name,
              style: TextStyle(
                fontSize: 28
              )
            ),
          )
        ),

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

        ActionButtons(
          isLoading: _isLoading,
          flower: widget.flower,
          soilMoisture: soilMoisture,
          waterAmount: waterAmount,
          onPress: () {
            this.setState(() {
              this._isLoading = true;
            });
          },
        )
      ],
    );
  }
}
