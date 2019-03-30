import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../presentation/custom_icons_icons.dart';
import '../constants/availableReminders.dart';
import '../reminders.dart';

List<AvaiableReminder> getAvaiableReminderFromReminders(Reminders reminders) {
  List<Reminder> reminderItems = reminders.getRemindersAsList();

  List<AvaiableReminder> created = reminderItems.map((reminder) {
    switch (reminder.type) {
      case ReminderType.Water:
        return AvaiableReminder('water', CustomIcons.water_amount_small, ReminderBlueMain, ReminderType.Water);
      case ReminderType.Fertilize:
        return AvaiableReminder('fertilize', Icons.flash_on, BrownMain, ReminderType.Fertilize);
      case ReminderType.Rotate:
        return AvaiableReminder('rotate', Icons.rotate_left, ReminderPurpleMain, ReminderType.Rotate);
      default:
        return AvaiableReminder('none', Icons.warning, RedMain, ReminderType.Water);
    }
  }).toList();

  return created;
}
