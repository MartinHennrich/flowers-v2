import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class Intervall extends StatelessWidget {
  final Function(int) onSave;

  Intervall({
    @required this.onSave
  });

  @override
  Widget build(BuildContext context) {
    return FormField(
      initialValue: 5,
      onSaved: (int form) {
        onSave(form);
      },
      builder: (intervallFrom) {
        return Center(
          child: Container(
            margin: EdgeInsets.only(top: 16),
            padding: EdgeInsets.only(top: 16),
            child: Column(
              children: <Widget>[
                Text('Water frequency',
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
                        if (intervallFrom.value - 1 >= 1) {
                          intervallFrom.setValue(intervallFrom.value - 1);
                          intervallFrom.setState((){});
                        }
                      },
                      icon: Icon(
                        Icons.keyboard_arrow_left,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
                      child: Text(
                        intervallFrom.value.toString(),
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
                        intervallFrom.setValue(intervallFrom.value + 1);
                        intervallFrom.setState((){});
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
      },
    );
  }
}
