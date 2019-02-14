import 'package:flutter/material.dart';

import '../../utils/firebase.dart';
import '../../actions/actions.dart';
import '../create-flower/intervall.dart';
import '../create-flower/pickTime.dart';
import '../../flower.dart';
import '../../store.dart';
import '../../constants/colors.dart';
import '../../utils/colors.dart';
import '../../utils/notifications.dart';
import './daysLeft.dart';
import './reminderInfoPanel.dart';
import '../../presentation/custom_icons_icons.dart';

class ReminderOverviewPage extends StatefulWidget {
  final Reminder reminder;
  final Flower flower;

  ReminderOverviewPage({
    this.flower,
    this.reminder
  });

  @override
  State<StatefulWidget> createState() {
    return ReminderOverviewPageState();
  }
}

class FlowerFormData {
  DateTime lastTime = DateTime.now();
  bool isAvtive = true;
  DateTime notificationTime = DateTime(2019, 1, 1, 8, 0);
  int intervall = 5;
}

class ReminderOverviewPageState extends State<ReminderOverviewPage> {
  final _formKey = GlobalKey<FormState>();
  FlowerFormData flowerFormData = FlowerFormData();

  bool isEdited = false;
  int currentInterval = 0;
  int initialInterval = 0;

  Map<String, dynamic> notificationTime;
  TimeOfDay initialTimeOfDay;

  Color mainColor;

  @override
  void initState() {
    super.initState();
    currentInterval = widget.reminder.interval;
    initialInterval = widget.reminder.interval;

    mainColor = getReminderColor(widget.reminder.type, true);
    notificationTime = {
      'enum': dateTimPickTimes(widget.reminder.timeOfDayForNotification),
      'time': TimeOfDay.fromDateTime(widget.reminder.timeOfDayForNotification)
    };
    initialTimeOfDay = TimeOfDay.fromDateTime(widget.reminder.timeOfDayForNotification);
  }

  void _setIsEdited() {
    setState(() {
      if (currentInterval == initialInterval &&
        notificationTime['time'].toString() == initialTimeOfDay.toString()
      ) {
        isEdited = false;
      } else {
        isEdited = true;
      }
    });
  }

  Icon _getIcon() {
    IconData icon;

    switch (widget.reminder.type) {
      case ReminderType.Water:
        icon = CustomIcons.water_amount_small;
        break;
      case ReminderType.Fertilize:
        icon = Icons.flash_on;
        break;
      case ReminderType.Rotate:
        icon = Icons.rotate_left;
        break;
      default:
        icon = Icons.warning;
    }

    return Icon(
      icon,
      size: 128,
      color: mainColor
    );
  }

  Future<void> _onEditFlower() async {
    Flower flower = widget.flower;
    Reminder reminder = widget.reminder;

    DateTime nextTime = flowerFormData
      .lastTime
      .add(Duration(days: flowerFormData.intervall));

    reminder.nextTime = nextTime;
    reminder.interval = flowerFormData.intervall;
    reminder.timeOfDayForNotification = flowerFormData.notificationTime;

    flower.reminders.updateReminder(reminder);

    try {
      await database.updateflower(flower);

      AppStore.dispatch(UpdateFlowerAction(flower));
      Navigator.pop(context);

      rescheduleNotification(
        flower.key,
        flower.name,
        flower.reminders.water.nextTime,
        flower.reminders.water.timeOfDayForNotification
      );
    } catch (e) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: Text('${widget.reminder.key.toUpperCase()} REMINDER',),
        actions: <Widget>[
          FlatButton(
            onPressed: isEdited ? () {
              _formKey.currentState.save();
              _onEditFlower();

            } : null,
            child: Text(
              'SAVE',
              style: TextStyle(
                color: isEdited ? mainColor : Colors.black
              )
            ),
          )
        ],
      ),
      body: ListView(
        padding: EdgeInsets.only(bottom: 44),
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 160,
                  height: 200,
                  alignment: Alignment(0, 0),
                  child: _getIcon()
                ),
                Expanded(child:DaysLeft(
                  reminder: widget.reminder,
                  color: mainColor
                ))
              ],
            )
          ),
          ReminderInfoPanel(reminder: widget.reminder),

          Form(
            key: _formKey,
            child: Container(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 24),
                    child: Intervall(
                      initialValue: widget.reminder.interval,
                      onSave: (int intervall) {
                        flowerFormData.intervall = intervall;
                      },
                      onChange: (value) {
                        setState(() {
                          currentInterval = value;
                        });
                        _setIsEdited();
                      },
                      type: widget.reminder.key
                    )
                  ),

                  PickTimeForm(
                    intialValue: notificationTime,
                    onChange: (Map<String, dynamic> value) {
                      setState(() {
                        notificationTime = value;
                      });
                      _setIsEdited();
                    },
                    onSave: (DateTime time) {
                      flowerFormData.notificationTime = time;
                    },
                  ),

                  /* FormField(
                    initialValue: widget.reminder.isActive,
                    onSaved: (bool isActive) {
                      flowerFormData.isAvtive = isActive;
                    },
                    builder: (switchFrom) {
                      return Container(
                        child: Column(
                          children: <Widget>[
                            Text(switchFrom.value ? 'Deactivate' : 'Activate'),
                            Switch(
                              value: switchFrom.value,
                              onChanged: (bool value) {
                                switchFrom.setValue(value);
                                switchFrom.setState((){});
                              },
                            )
                          ],
                        )
                      );
                    },
                  ) */
                ],
              )
            )
          )
        ],
      )
    );
  }
}
