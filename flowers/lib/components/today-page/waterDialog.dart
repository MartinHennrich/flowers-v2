import 'package:flutter/material.dart';

import '../../flower.dart';
import '../../constants/colors.dart';
import '../../presentation/custom_icons_icons.dart';
import '../../constants/enums.dart';
import '../../utils/firebase-redux.dart';
import '../../utils/soilMoisture.dart';

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
                    image: NetworkImage(widget.flower.imageUrl),
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

        SoilMoistureSections(
          onPress: (type) {
            setState(() {
              this.soilMoisture = type;
            });
          },
          soilMoisture: soilMoisture,
        ),

        WaterAmountSections(
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

class SoilMoistureSections extends StatelessWidget {
  final void Function(SoilMoisture) onPress;
  final SoilMoisture soilMoisture;

  SoilMoistureSections({
    this.onPress,
    this.soilMoisture
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(24, 48, 24, 0),
      child: Column(
        children: <Widget>[
          Text('soil moisture'),
          Container(
            padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(CustomIcons.soil_0),
                  iconSize: 32,
                  padding: EdgeInsets.all(0),
                  color: soilMoisture == SoilMoisture.Soil0 ? MainSecondColor : Colors.black,
                  onPressed: () {
                    onPress(SoilMoisture.Soil0);
                  },
                ),
                IconButton(
                  icon: Icon(CustomIcons.soil_25),
                  iconSize: 32,
                  color: soilMoisture == SoilMoisture.Soil25 ? MainSecondColor : Colors.black,
                  onPressed: () {
                    onPress(SoilMoisture.Soil25);
                  },
                ),
                IconButton(
                  icon: Icon(CustomIcons.soil_50),
                  iconSize: 32,
                  color: soilMoisture == SoilMoisture.Soil50 ? MainSecondColor : Colors.black,
                  onPressed: () {
                    onPress(SoilMoisture.Soil50);
                  },
                ),
                IconButton(
                  icon: Icon(CustomIcons.soil_100),
                  iconSize: 32,
                  color: soilMoisture == SoilMoisture.Soil75 ? MainSecondColor : Colors.black,
                  onPressed: () {
                    onPress(SoilMoisture.Soil75);
                  },
                ),
                IconButton(
                  icon: Icon(CustomIcons.soil_75),
                  iconSize: 32,
                  color: soilMoisture == SoilMoisture.Soil100 ? MainSecondColor : Colors.black,
                  onPressed: () {
                    onPress(SoilMoisture.Soil100);
                  },
                ),
              ],
            )
          ),
        ],
      ),
    );
  }
}

class WaterAmountSections extends StatelessWidget {
  final void Function(WaterAmount) onPress;
  final WaterAmount waterAmount;

  WaterAmountSections({
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
                  color: waterAmount == WaterAmount.Small ? MainSecondColor : Colors.black,
                  onPressed: () {
                    onPress(WaterAmount.Small);
                  },
                ),
                IconButton(
                  icon: Icon(CustomIcons.water_amount_medium),
                  iconSize: 48,
                  color: waterAmount == WaterAmount.Normal ? MainSecondColor : Colors.black,
                  onPressed: () {
                    onPress(WaterAmount.Normal);
                  },
                ),
                IconButton(
                  icon: Icon(CustomIcons.water_amount_large),
                  iconSize: 40,
                  color: waterAmount == WaterAmount.Lots ? MainSecondColor : Colors.black,
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
