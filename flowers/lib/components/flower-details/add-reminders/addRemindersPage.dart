import 'package:flutter/material.dart';

import '../../../actions/actions.dart';
import '../../../flower.dart';
import '../../../reminders.dart';
import '../../../store.dart';
import '../../../utils/avaiableReminderHelper.dart';
import '../../../utils/firebase.dart';
import '../../../utils/notifications.dart';
import '../../create-flower/addReminders.dart';

class AddRemindersPage extends StatefulWidget {
  final Flower flower;
  final Reminders reminders;

  AddRemindersPage({
    this.flower,
    this.reminders
  });

  @override
  State<StatefulWidget> createState() {
    return AddRemindersPageState();
  }
}

class AddRemindersPageState extends State<AddRemindersPage> {
  final _formKey = GlobalKey<FormState>();
  Reminders remindersFormData = Reminders();
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    remindersFormData = widget.reminders;
  }

  void _onAddReminders() async {
    Flower flower = widget.flower;
    flower.reminders = remindersFormData;

    setState(() {
      isSaving = true;
    });
    try {
      await database.updateflower(flower);
      AppStore.dispatch(UpdateFlowerAction(flower));
      Navigator.pop(context);

      scheduleNotificationsForReminders(flower, remindersFormData);
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
        title: Text('ADD REMINDERS'),
        actions: <Widget>[
          FlatButton(
            onPressed: !isSaving ? () {
              _formKey.currentState.save();
              _onAddReminders();
            } : null,
            child: Text('SAVE'),
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AddReminders(
                onSave: (Reminders reminders) {
                  remindersFormData = reminders;
                },
                defaultReminders: widget.reminders.clone(),
                defaultCreatedReminders: getAvaiableReminderFromReminders(widget.reminders),
              ),
            ]
          )
        )
      )
    );
  }
}
