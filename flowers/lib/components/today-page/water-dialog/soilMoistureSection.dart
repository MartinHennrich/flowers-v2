import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../presentation/custom_icons_icons.dart';
import '../../../constants/enums.dart';

class SoilMoistureSection extends StatelessWidget {
  final void Function(SoilMoisture) onPress;
  final SoilMoisture soilMoisture;

  SoilMoistureSection({
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
                  color: soilMoisture == SoilMoisture.Soil0 ? PurpleMain : Colors.black,
                  onPressed: () {
                    onPress(SoilMoisture.Soil0);
                  },
                ),
                IconButton(
                  icon: Icon(CustomIcons.soil_25),
                  iconSize: 32,
                  color: soilMoisture == SoilMoisture.Soil25 ? PurpleMain : Colors.black,
                  onPressed: () {
                    onPress(SoilMoisture.Soil25);
                  },
                ),
                IconButton(
                  icon: Icon(CustomIcons.soil_50),
                  iconSize: 32,
                  color: soilMoisture == SoilMoisture.Soil50 ? PurpleMain : Colors.black,
                  onPressed: () {
                    onPress(SoilMoisture.Soil50);
                  },
                ),
                IconButton(
                  icon: Icon(CustomIcons.soil_100),
                  iconSize: 32,
                  color: soilMoisture == SoilMoisture.Soil75 ? PurpleMain : Colors.black,
                  onPressed: () {
                    onPress(SoilMoisture.Soil75);
                  },
                ),
                IconButton(
                  icon: Icon(CustomIcons.soil_75),
                  iconSize: 32,
                  color: soilMoisture == SoilMoisture.Soil100 ? PurpleMain : Colors.black,
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
