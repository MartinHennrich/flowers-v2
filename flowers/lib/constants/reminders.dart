import 'package:flutter/material.dart';

import './colors.dart';
import '../presentation/custom_icons_icons.dart';
import '../reminders.dart';

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

List<AvaiableReminder> avaiableReminders = [
  AvaiableReminder('water', CustomIcons.water_amount_small, ReminderBlueMain, ReminderType.Water),
  AvaiableReminder('fertilize', Icons.flash_on, BrownMain, ReminderType.Fertilize),
  AvaiableReminder('rotate', Icons.rotate_left, ReminderPurpleMain, ReminderType.Rotate)
];

