import 'package:flutter/material.dart';

import '../../flower.dart';
import '../../utils/dateHelpers.dart';

class DaysLeft extends StatelessWidget {

  final Color color;
  final Reminder reminder;

  DaysLeft({
    this.reminder,
    this.color
  });

  @override
  Widget build(BuildContext context) {
    DateTime today = preSetTimeFrame(DateTime.now());
    DateTime nextWatertime = preSetTimeFrame(reminder.nextTime);
    Duration diff = nextWatertime.difference(today);
    int daysLeft = 0;

    if (diff.inDays <= 0) {
      if (diff.inHours >= 1) {
        daysLeft = 1;
      } else {
        daysLeft = 0;
      }
    } else {
      daysLeft = diff.inDays;
    }

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
