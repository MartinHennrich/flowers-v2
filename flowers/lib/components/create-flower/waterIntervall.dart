import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class WaterIntervall extends StatelessWidget {
  final Function(int) onSave;

  WaterIntervall({
    @required this.onSave
  });

  @override
  Widget build(BuildContext context) {
    return FormField(
      initialValue: 5,
      onSaved: (int form) {
        onSave(form);
      },
      builder: (waterintervallFrom) {
        return Center(
          child: Container(
            margin: EdgeInsets.only(top: 16),
            padding: EdgeInsets.only(top: 16),
            child: Column(
              children: <Widget>[
                Text('Watering intervall',
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16
                  )
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      alignment: Alignment(0, 0),
                      iconSize: 44,
                      color: Colors.black26,
                      onPressed: () {
                        if (waterintervallFrom.value - 1 >= 1) {
                          waterintervallFrom.setValue(waterintervallFrom.value - 1);
                          waterintervallFrom.setState((){});
                        }
                      },
                      icon: Icon(
                        Icons.keyboard_arrow_left,
                      ),
                    ),
                    Container(
                      child: Text(
                        waterintervallFrom.value.toString(),
                        style: TextStyle(
                          fontSize: 40,
                          color: SecondMainColor
                        ),
                      ),
                    ),
                    IconButton(
                      alignment: Alignment(0, 0),
                      iconSize: 44,
                      color: Colors.black26,
                      onPressed: () {
                        waterintervallFrom.setValue(waterintervallFrom.value + 1);
                        waterintervallFrom.setState((){});
                      },
                      icon: Icon(
                        Icons.keyboard_arrow_right,
                      ),
                    )
                  ],
                )
              ],
            )
          )
        );
      },
    );
  }
}
