import 'package:flutter/material.dart';

import '../../constants/reminders.dart';
import './avaiableReminderCard.dart';
import '../../flower.dart';

class AddReminders extends StatefulWidget {
  final Function(Reminders) onSave;

  AddReminders({
    this.onSave
  });

  @override
  State<StatefulWidget> createState() {
    return AddRemindersState();
  }
}

class AddRemindersState extends State<AddReminders> {
  List<AvaiableReminder> _avaiableReminders = avaiableReminders;
  List<AvaiableReminder> _createdReminders = [];

  void _setReminders(Reminder reminder) {

    setState(() {
      AvaiableReminder a;
      _avaiableReminders = _avaiableReminders.where((r) {
        if (r.reminderType == reminder.type) {
          a = r;
          return false;
        }
        return true;
      }).toList();
      if (_avaiableReminders == null) {
        _avaiableReminders = [];
      }
      _createdReminders.add(a);
    });

  }

  void _removeReminder(Reminder reminder) {
    setState(() {
      AvaiableReminder a;
      _createdReminders = _createdReminders.where((r) {
        if (r.reminderType == reminder.type) {
          a = r;
          return false;
        }
        return true;
      }).toList();
      if (_createdReminders == null) {
        _createdReminders = [];
      }
      _avaiableReminders.add(a);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FormField(
      initialValue: Reminders(),
      onSaved: (Reminders reminders) {
        widget.onSave(reminders);
      },
      builder: (FormFieldState<Reminders> remindersForm) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _createdReminders.length > 0
              ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text('CREATED REMINDERS',
                  style: TextStyle(
                    color: Colors.black45,
                    fontSize: 16
                  )
                )
              )
            : Container(),

             _createdReminders.length > 0
              ? Container(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: GridView.count(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  shrinkWrap: true,
                  childAspectRatio: 1.6,
                  primary: false,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 12.0,
                  crossAxisCount: 2,
                  children: _createdReminders.map((avaiableReminder) {
                    return AvaiableReminderCard(
                      avaiableReminder,
                      (Reminder reminder) {
                        _removeReminder(reminder);
                      },
                      remove: true
                    );
                  }).toList()
                )
              )
              : Container(),

            _avaiableReminders.length > 0
              ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text('AVAIABLE REMINDERS',
                  style: TextStyle(
                    color: Colors.black45,
                    fontSize: 16
                  )
                )
              )
              : Container(),
            _avaiableReminders.length > 0
              ? Container(
                padding: EdgeInsets.only(top: 24),
                child: GridView.count(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  shrinkWrap: true,
                  childAspectRatio: 1.6,
                  primary: false,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 12.0,
                  crossAxisCount: 2,
                  children: _avaiableReminders.map((avaiableReminder) {
                    return AvaiableReminderCard(
                      avaiableReminder,
                      (Reminder reminder) {
                        var r = remindersForm.value.updateReminder(reminder);
                        remindersForm.setValue(r);
                        remindersForm.setState((){});
                        _setReminders(reminder);
                      }
                    );
                  }).toList()
                )
              )
              : Container()
          ]
        );
      }
    );
  }
}
