import 'package:flutter/material.dart';

import '../presentation/custom_icons_icons.dart';
import '../reminders.dart';

IconData getReminderIcon(Reminder reminder) {
  IconData icon;

  switch (reminder.type) {
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

  return icon;
}
