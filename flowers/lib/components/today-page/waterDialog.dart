import 'package:flutter/material.dart';

import '../../flower.dart';
import '../../constants/colors.dart';

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

enum WaterAmount {
  Small,
  Normal,
  Lots
}

enum SoilMoisture {
  SuperDry,
  Dry,
  Moist,
  Wet
}

class WaterDialogState extends State<WaterDialog> {
  WaterAmount waterAmount = WaterAmount.Normal;
  SoilMoisture soilMoisture = SoilMoisture.Moist;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: EdgeInsets.all(0),
      children: <Widget>[
        Center(
          child: Container(
            margin: EdgeInsets.fromLTRB(0, 16, 0, 16),
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
        Center(
          child: Container(
            child: Text(widget.flower.name,
              style: TextStyle(
                fontSize: 28
              )
            ),
          )
        ),

        WaterAmountSections(
          onPress: (amount) {
            setState(() {
              this.waterAmount = amount;
            });
          },
          waterAmount: waterAmount,
        ),

        SoilMoistureSections(
          onPress: (type) {
            setState(() {
              this.soilMoisture = type;
            });
          },
          soilMoisture: soilMoisture,
        ),

        Container(
          height: 100,
          color: Colors.red,
          child: Text('ehj')
        )
      ],
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
      padding: EdgeInsets.fromLTRB(0, 8, 0, 6),
      child: Column(
        children: <Widget>[
          Text('Soil moisture'),
          Container(
            padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 48,
                      width: 48,
                      alignment: AlignmentDirectional(0.0, 0.0),
                    child: FlatButton(
                      color: soilMoisture == SoilMoisture.SuperDry ? MainSecondColor : Color.fromRGBO(0, 0, 0, 0.1),
                      shape: CircleBorder(),
                      child: Icon(Icons.favorite_border),
                      onPressed: () {
                        onPress(SoilMoisture.SuperDry);
                      },
                    )),
                    FlatButton(
                      color: soilMoisture == SoilMoisture.Dry ? MainSecondColor : Color.fromRGBO(0, 0, 0, 0.1),
                      shape: CircleBorder(),
                      child: Icon(Icons.favorite_border),
                      onPressed: () {
                        onPress(SoilMoisture.Dry);
                      },
                    ),
                    FlatButton(
                      color: soilMoisture == SoilMoisture.Moist ? MainSecondColor : Color.fromRGBO(0, 0, 0, 0.1),
                      shape: CircleBorder(),
                      child: Icon(Icons.favorite_border),
                      onPressed: () {
                        onPress(SoilMoisture.Moist);
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                    FlatButton(
                      color: soilMoisture == SoilMoisture.Wet ? MainSecondColor : Color.fromRGBO(0, 0, 0, 0.1),
                      shape: CircleBorder(),
                      child: Icon(Icons.favorite_border),
                      onPressed: () {
                        onPress(SoilMoisture.Wet);
                      },
                    ),
                    FlatButton(
                      color: soilMoisture == SoilMoisture.Wet ? MainSecondColor : Color.fromRGBO(0, 0, 0, 0.1),
                      shape: CircleBorder(),
                      child: Icon(Icons.favorite_border),
                      onPressed: () {
                        onPress(SoilMoisture.Wet);
                      },
                    ),
                  ],
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
      padding: EdgeInsets.fromLTRB(0, 8, 0, 6),
      child: Column(
        children: <Widget>[
          Text('Water amount'),
          Container(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                  color: waterAmount == WaterAmount.Small ? MainSecondColor : Color.fromRGBO(0, 0, 0, 0.1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.horizontal(left: Radius.circular(30.0))),
                  child: Text('small'),
                  onPressed: () {
                    onPress(WaterAmount.Small);
                  },
                ),
                FlatButton(
                  color: waterAmount == WaterAmount.Normal ? MainSecondColor : Color.fromRGBO(0, 0, 0, 0.1),
                  child: Text('normal'),
                  onPressed: () {
                    onPress(WaterAmount.Normal);
                  },
                ),
                FlatButton(
                  color: waterAmount == WaterAmount.Lots ? MainSecondColor : Color.fromRGBO(0, 0, 0, 0.1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.horizontal(right: Radius.circular(30.0))),
                  child: Text('lots'),
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
