import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class IntervallPure extends StatelessWidget {
  final Function(int) onIncrease;
  final Function(int) onDecrease;
  final int value;
  final String type;

  IntervallPure({
    @required this.onIncrease,
    @required this.onDecrease,
    @required this.value,
    this.type = ''
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 16),
        padding: EdgeInsets.only(top: 16),
        child: Column(
          children: <Widget>[
            Text('$type every',
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
                    if (value - 1 >= 1) {
                      onDecrease(value - 1);
                    }
                  },
                  icon: Icon(
                    Icons.keyboard_arrow_left,
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
                  child: Text(
                    value.toString(),
                    style: TextStyle(
                      fontSize: 40,
                      color: BlueMain
                    ),
                  ),
                ),
                IconButton(
                  alignment: Alignment(0, 0),
                  iconSize: 44,
                  color: Colors.black26,
                  onPressed: () {
                    onDecrease(value + 1);
                  },
                  icon: Icon(
                    Icons.keyboard_arrow_right,
                  ),
                )
              ],
            ),
            Text('days',
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16
              )
            ),
          ],
        )
      )
    );
  }
}


class Intervall extends StatelessWidget {
  final Function(int) onSave;
  final Function(int) onChange;
  final int initialValue;
  String type;

  Intervall({
    @required this.onSave,
    this.initialValue = 5,
    this.type,
    this.onChange
  });

  @override
  Widget build(BuildContext context) {
    return FormField(
      initialValue: initialValue,
      onSaved: (int form) {
        onSave(form);
      },
      builder: (intervallFrom) {
        return IntervallPure(
          value: intervallFrom.value,
          onDecrease: (value) {
            if (onChange != null) {
              onChange(value);
            }
            intervallFrom.setValue(value);
            intervallFrom.setState((){});
          },
          onIncrease: (value) {
            if (onChange != null) {
              onChange(value);
            }
            intervallFrom.setValue(value);
            intervallFrom.setState((){});
          },
          type: type,
        );
      },
    );
  }
}
