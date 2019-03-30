import 'package:flutter/material.dart';

import '../../constants/reminders.dart';
import '../../constants/colors.dart';
import '../../reminders.dart';
import './createReminder.dart';

class AvaiableReminderCard extends StatelessWidget {
  final AvaiableReminder avaiableReminder;
  final Function(Reminder) onCreate;
  final Function onBeforeCreate;
  final bool remove;
  final bool isLocked;

  AvaiableReminderCard(
    this.avaiableReminder,
    this.onCreate,
    {
      this.onBeforeCreate,
      this.remove = false,
      this.isLocked = false,
    }
  );

  void _openDialog(AvaiableReminder reminder, BuildContext context) {
    if (onBeforeCreate != null) {
      onBeforeCreate(avaiableReminder.title);
    }
    showDialog(
      context: context,
      builder: (_) => CreateReminder(
        reminder.reminderType,
        (Reminder reminder) {
          onCreate(reminder);
        })
    );
  }

  void _openDeleteDialog(AvaiableReminder reminder, BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => SimpleDialog(
        contentPadding: EdgeInsets.all(0),
        title: Text('Remove ${reminder.title} reminder?',),
        children: <Widget>[
          ButtonBar(
            children: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('NO'),
              ),
              FlatButton(
                color: RedMain,
                onPressed: () {
                  var r = Reminder(
                    type: reminder.reminderType
                  );
                  onCreate(r);
                  Navigator.pop(context);
                },
                child: Text(
                  'YES REMOVE',
                  style: TextStyle(
                    color: Colors.white
                  )
                ),
              )
            ],
          )
        ],
      )
    );
  }

  Widget _getReminderCard(AvaiableReminder reminder, BuildContext context) {
    Color color = reminder.color;
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
            if (remove) {
              _openDeleteDialog(reminder, context);
            } else {
              _openDialog(reminder, context);
            }
          },
          child: Stack(
            children: <Widget>[
              isLocked
                ? Positioned(
                top: 8,
                left: 8,
                child: Icon(
                  Icons.videocam,
                  size: 14,
                  color: Colors.black26,
                ),
              ) : Container(),
              Container(
              alignment: Alignment(0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      reminder.title.toUpperCase(),
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black
                      )
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 8),
                      child: Icon(
                        reminder.iconData,
                        color: reminder.color,
                      )
                    )
                  ]
                )
              )
            ]
          )
        )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _getReminderCard(avaiableReminder, context);
  }
}
