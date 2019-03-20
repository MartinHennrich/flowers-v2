import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';

import '../../constants/reminders.dart';
import './avaiableReminderCard.dart';
import '../../flower.dart';
import '../../utils/rewardAdHelpers.dart';
import '../../ad.dart';
import '../../store.dart';

class AddReminders extends StatefulWidget {
  final Function(Reminders) onSave;
  final List<AvaiableReminder> defaultCreatedReminders;
  final Reminders defaultReminders;

  AddReminders({
    this.onSave,
    this.defaultCreatedReminders,
    this.defaultReminders
  });

  @override
  State<StatefulWidget> createState() {
    return AddRemindersState();
  }
}

class AddRemindersState extends State<AddReminders> {
  List<AvaiableReminder> _avaiableReminders = avaiableReminders;
  List<AvaiableReminder> _createdReminders = [];
  bool isUnlocked = false;

  @override
  void initState() {
    super.initState();
    if (widget.defaultCreatedReminders != null) {
      _createdReminders = widget.defaultCreatedReminders;
      _avaiableReminders = avaiableReminders
        .where((AvaiableReminder a) {
          var includesItem = _createdReminders
            .firstWhere((AvaiableReminder b) {
              if (b.reminderType == a.reminderType) {
                return true;
              }
              return false;
            }, orElse: () => null);
          return includesItem == null;
        }).toList();
    }

    isRemindersUnlocked()
      .then((bool isUnlocked) {
        setState(() {
          this.isUnlocked = isUnlocked;
        });
      });
    RewardedVideoAd.instance.listener = (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
      if (event == RewardedVideoAdEvent.rewarded) {
        setState(() {
          this.isUnlocked = true;
        });
        setRemindersLockStatus(DateTime.now().toIso8601String());
      }
    };
  }

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
      initialValue: widget.defaultReminders != null ? widget.defaultReminders : Reminders(),
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
                        var r = remindersForm.value.removeReminderByType(reminder.type);
                        remindersForm.setValue(r);
                        remindersForm.setState((){});
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
                child: Text('AVAILABLE REMINDERS',
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
                      },
                      onBeforeCreate: (String key) {
                        if (!isUnlocked && AppStore.state.flowers.length > 0) {
                          RewardedVideoAd.instance.load(
                            adUnitId: rewardId,
                            targetingInfo: targetingInfo
                          )..then((_) {
                            RewardedVideoAd.instance..show();
                          });
                        }
                      },
                      isLocked: !isUnlocked && AppStore.state.flowers.length > 0,
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
