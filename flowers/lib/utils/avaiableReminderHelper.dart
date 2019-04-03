import 'package:flutter/material.dart';

import '../constants/availableReminders.dart';
import '../constants/colors.dart';
import '../presentation/custom_icons_icons.dart';
import '../reminders.dart';

List<AvaiableReminder> getAvaiableReminderFromReminders(Reminders reminders) {
  List<Reminder> reminderItems = reminders.getRemindersAsList();

  List<AvaiableReminder> created = reminderItems.map((reminder) {
    switch (reminder.type) {
      case ReminderType.Water:
        return avaiableWaterReminder;
      case ReminderType.Fertilize:
        return avaiableFertilizeReminder;
      case ReminderType.Rotate:
        return avaiableRotateReminder;
      default:
        return AvaiableReminder('none', Icons.warning, RedMain, ReminderType.Water);
    }
  }).toList();

  return created;
}

AvaiableReminder getAvaiableReminderFromReminder(Reminder reminder) {
  switch (reminder.type) {
    case ReminderType.Water:
      return avaiableWaterReminder;
    case ReminderType.Fertilize:
      return avaiableFertilizeReminder;
    case ReminderType.Rotate:
      return avaiableRotateReminder;
    default:
      return AvaiableReminder('none', Icons.warning, RedMain, ReminderType.Water);
  }
}
