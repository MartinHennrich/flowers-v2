import 'package:flutter/material.dart';

import '../../flower.dart';
import '../../utils/dateHelpers.dart';

class ReminderInfoPanel extends StatelessWidget {
  final Reminder reminder;

  ReminderInfoPanel({
    this.reminder,
  });

  String _getNotificationTime() {
    DateTime time = reminder.timeOfDayForNotification;
    return ' ${time.hour < 10 ? '0' + time.hour.toString() : time.hour}:${time.minute < 10 ? '0' + time.minute.toString() : time.minute}';
  }

  String _getDayToWaterName() {
    DateTime today = preSetTimeFrame(DateTime.now());
    DateTime tomorrow = today.add(Duration(days: 1));
    DateTime nextTime = preSetTimeFrame(reminder.nextTime);

    if (tomorrow.day == nextTime.day && tomorrow.month == nextTime.month) {
      return 'tomorrow';
    }

    if (nextTime.day < today.day && today.month == nextTime.month) {
      return 'today!!';
    }

    if (today.day == nextTime.day && today.month == today.month) {
      return 'today';
    }

    return '${reminder.nextTime.month} / ${reminder.nextTime.day}';
  }

  String _getLastWaterTimeName() {
    DateTime today = preSetTimeFrame(DateTime.now());
    DateTime lastWateredTime = preSetTimeFrame(reminder.lastTime);
    DateTime yesterday = today.subtract(Duration(days: 1));

    if (today.day == lastWateredTime.day && today.month == lastWateredTime.month) {
      return 'today';
    }

    if (yesterday.day == lastWateredTime.day && yesterday.month == today.month) {
      return 'yesterday';
    }

    return '${lastWateredTime.month} / ${lastWateredTime.day}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 32, 16, 6),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(right: 16),
            padding: EdgeInsets.only(left: 16),
            width: 144,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('LAST WATERED',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black38,
                    fontSize: 12
                  )),
                Padding(
                  padding: EdgeInsets.only(top: 6),
                  child: Text(
                    _getLastWaterTimeName(),
                    style: TextStyle(
                      fontSize: 28
                    )
                  )
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('NEXT WATERING',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black38,
                    fontSize: 12
                  )),
                Padding(
                  padding: EdgeInsets.only(top: 6),
                  child: RichText(
                    text: TextSpan(
                      text: _getDayToWaterName(),
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.black
                      ),
                      children: [
                        TextSpan(
                          text: _getNotificationTime(),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54
                          ),
                        )
                      ]
                    ),
                  )
                ),
              ],
            ),
          )
        ]
      )
    );
  }
}
