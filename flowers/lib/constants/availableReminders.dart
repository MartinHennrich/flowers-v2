import 'package:flutter/material.dart';

import '../presentation/custom_icons_icons.dart';
import '../reminders.dart';
import './colors.dart';

class AvaiableReminder {
  final String title;
  final IconData iconData;
  final Color color;
  final ReminderType reminderType;

  AvaiableReminder(
    this.title,
    this.iconData,
    this.color,
    this.reminderType
  );
}

AvaiableReminder avaiableWaterReminder = AvaiableReminder('water', CustomIcons.water_amount_small, ReminderBlueMain, ReminderType.Water);
AvaiableReminder avaiableFertilizeReminder = AvaiableReminder('fertilize', Icons.flash_on, BrownMain, ReminderType.Fertilize);
AvaiableReminder avaiableRotateReminder = AvaiableReminder('rotate', Icons.rotate_left, ReminderPurpleMain, ReminderType.Rotate);

List<AvaiableReminder> avaiableReminders = [
  avaiableWaterReminder,
  avaiableFertilizeReminder,
  avaiableRotateReminder,
];

