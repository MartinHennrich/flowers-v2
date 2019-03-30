import 'package:flutter/material.dart';

import './lastWaterTime.dart';
import './intervall.dart';
import './pickTime.dart';
import '../../reminders.dart';
import '../../constants/colors.dart';
import 'package:gradient_widgets/gradient_widgets.dart';

class CreateReminder extends StatefulWidget {
  final Function(Reminder) onCreate;
  final ReminderType reminderType;

  CreateReminder(
    this.reminderType,
    this.onCreate
  );

  @override
  State<StatefulWidget> createState() {
    return CreateReminderState();
  }
}

class CreateReminderState extends State<CreateReminder> {
  final _formKey = GlobalKey<FormState>();
  Reminder reminderFormData = Reminder(
    lastTime: DateTime.now()
  );

  String _getName() {
    switch (widget.reminderType) {
      case ReminderType.Water:
        return 'Water';
      case ReminderType.Fertilize:
        return 'Fertilize';
      case ReminderType.Rotate:
        return 'Rotate';
      default:
        return '';
    }
  }

  void _onCreate() {
    DateTime nextWaterTime = reminderFormData
      .lastTime
      .add(Duration(days: reminderFormData.interval));

    var r = Reminder(
      interval: reminderFormData.interval,
      lastTime: reminderFormData.lastTime,
      nextTime: nextWaterTime,
      timeOfDayForNotification: reminderFormData.timeOfDayForNotification,
      key: _getName().toLowerCase(),
      isActive: true,
      type: widget.reminderType
    );

    widget.onCreate(r);
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: EdgeInsets.all(0),

      title: Text('CREATE ${_getName().toUpperCase()} REMINDER'),
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
        ),
        Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              LastWaterTime(
                onSave: (DateTime lastTime) {
                  reminderFormData.lastTime = lastTime;
                },
                type: _getName()
              ),


              Intervall(
                onSave: (int interval) {
                  reminderFormData.interval = interval;
                },
                type: _getName(),
              ),

              PickTimeForm(
                onSave: (DateTime time) {
                  reminderFormData.timeOfDayForNotification = time;
                },
              ),
            ],
          )
        ),
        ButtonBar(
          children: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('CANCEL'),
            ),
            GradientButton(
                gradient: BlueGradient,
                elevation: 0,
                shapeRadius: BorderRadius.horizontal(left: Radius.circular(0)),
                callback: () {
                  _formKey.currentState.save();
                  _onCreate();
                  Navigator.pop(context);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('ADD',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white
                      ),
                    ),
                  ],
                )
              ),
          ],
        )
      ]
    );
  }
}
