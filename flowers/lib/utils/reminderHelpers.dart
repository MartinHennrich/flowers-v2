import 'package:flutter/material.dart';

import '../constants/colors.dart';
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

Color getReminderColor(ReminderType type, bool isActive) {
  if (!isActive) {
    return Colors.black;
  }

  if (type == ReminderType.Water) {
    return ReminderBlueSecond;
  }

  if (type == ReminderType.Fertilize) {
    return BrownMain;
  }

  if (type == ReminderType.Rotate) {
    return ReminderPurpleMain;
  }

  return RedMain;
}
