import 'package:flutter/material.dart';

import '../../flower.dart';
import '../../utils/timeHelpers.dart';

class DaysLeft extends StatelessWidget {

  final Color color;
  final Reminder reminder;

  DaysLeft({
    this.reminder,
    this.color
  });

  @override
  Widget build(BuildContext context) {
    int daysLeft = getDaysLeft(reminder);

    return Container(
      height: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('$daysLeft', style: TextStyle(
            fontSize: 80,
            color: color,
          )),
          Container(
            child: Text('${daysLeft == 1 ? 'day' : 'days'}\nremaining',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black38
              )
            )
          ),
        ],
      )
    );
  }
}
