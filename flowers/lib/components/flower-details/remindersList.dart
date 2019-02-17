import 'package:flutter/material.dart';

import '../../flower.dart';
import '../../utils/dateHelpers.dart';
import '../../utils/colors.dart';
import './reminderOverviewPage.dart';
import '../../constants/reminders.dart';
import './add-reminders/addRemindersPage.dart';

class RemindersList extends StatelessWidget {
  final Reminders reminders;
  final Flower flower;

  RemindersList({
    this.reminders,
    this.flower
  });

  int _getDaysLeft(Reminder reminder) {
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

    return daysLeft;
  }

  Widget _addReminderCard(BuildContext context) {
    Color color = Colors.black12.withAlpha(50);
    List<Reminder> reminderList = reminders.getRemindersAsList();

    if (reminderList.length == avaiableReminders.length) {
      return Container();
    }

    return Container(
      width: 180,
      margin: EdgeInsets.fromLTRB(0, 0, 16, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 2, color: color),
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddRemindersPage(flower: flower, reminders: reminders,),
              ),
            );
          },
          child: Container(
            child: Icon(Icons.add, color: color, size: 44,),
          ),
        )
      ),
    );
  }

  Widget _getReminderCard(Reminder reminder, BuildContext context) {
    Color color = getReminderColor(reminder.type, reminder.isActive);
    Color _kKeyUmbraOpacity = color.withAlpha(51);
    Color _kKeyPenumbraOpacity = color.withAlpha(36);
    Color _kAmbientShadowOpacity = color.withAlpha(31);

    return Container(
      width: 180,
      margin: EdgeInsets.fromLTRB(0, 0, 16, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: <BoxShadow>[
          BoxShadow(offset: Offset(0.0, 2.0), blurRadius: 4.0, spreadRadius: -1.0, color: _kKeyUmbraOpacity),
          BoxShadow(offset: Offset(0.0, 4.0), blurRadius: 5.0, spreadRadius: 0.0, color: _kKeyPenumbraOpacity),
          BoxShadow(offset: Offset(0.0, 1.0), blurRadius: 10.0, spreadRadius: 0.0, color: _kAmbientShadowOpacity),
        ],
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReminderOverviewPage(flower: flower, reminder: reminder,),
              ),
            );
          },
          child: reminder.isActive
            ? _getActiveReminderCard(reminder, color, context)
            : _getUnactiveReminderCard(reminder, color, context)
        )
      ),
    );
  }

  Widget _getUnactiveReminderCard(Reminder reminder, Color color, BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(right: 12),
              alignment: Alignment(0, 0),
              child: Text(
                reminder.key.toUpperCase(),
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black
                )
              )
            ),
            Container(
              padding: EdgeInsets.only(right: 12),
              alignment: Alignment(0, 0),
              child: Text(
                'disabled',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black38
                )
              )
            )
          ],
        ))
      ],
    );
  }

  Widget _getActiveReminderCard(Reminder reminder, Color color, BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          alignment: Alignment(0, 0),
          width: 70,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(_getDaysLeft(reminder).toString(),
                style: TextStyle(
                  fontSize: _getDaysLeft(reminder) >= 100 ? 32 : 44,
                  color: color,
                )
              ),
              Text(
                '${_getDaysLeft(reminder) == 1 ? 'day' : 'days'} left',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black38
                ),
              )
            ],
          )

        ),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(right: 12),
              alignment: Alignment(0, 0),
              child: Text(
                reminder.key.toUpperCase(),
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black
                )
              )
            ),
            Container(
              padding: EdgeInsets.only(right: 12),
              alignment: Alignment(0, 0),
              child: Text(
                'every ${reminder.interval}${reminder.interval != 1 ? 'th' : ''} day',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black38
                )
              )
            )
          ],
        ))
      ],
    );
  }

  List<Widget> _getReminderCards(BuildContext context) {
    List<Reminder> reminderList = reminders.getRemindersAsList();

    return reminderList.map((reminder) {
      return _getReminderCard(
        reminder,
        context
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    var children = _getReminderCards(context);
    children.add(_addReminderCard(context));

    return Container(
      height: 150,
      margin: EdgeInsets.only(top: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(32, 0, 0, 16),
            child: Text('REMINDERS', style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black38,
              fontSize: 16
            ))
          ),
          Container(
            height: 108,
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              children: children,
            )
          )
        ]
      )
    );
  }
}
