import 'package:flutter/material.dart';

import '../constants/colors.dart';
import './dateHelpers.dart';
import '../reminders.dart';

LinearGradient getColorBasedOnTime(DateTime time, DateTime lastTime) {
  DateTime today = preSetTimeFrame(DateTime.now());
  DateTime _time = preSetTimeFrame(time);
  DateTime _lastTime = preSetTimeFrame(lastTime);

  Duration difference = _time.difference(today);
  int days = difference.inDays;

  if (today.day == _lastTime.day && _lastTime.month == today.month) {
    return BlueGradient;
  }

  if (days == 0) {
    return YellowGradient;
  }

  if (days > 0) {
    return GreenGradient;
  }

  return RedGradient;
}

Color getColorBasedOnTime2(DateTime time, DateTime lastTime) {
  DateTime today = preSetTimeFrame(DateTime.now());
  DateTime _time = preSetTimeFrame(time);
  DateTime _lastTime = preSetTimeFrame(lastTime);
  Duration difference = _time.difference(today);
  int days = difference.inDays;

  if (today.day == _lastTime.day && _lastTime.month == today.month) {
    return BlueMain;
  }

  if (days == 0) {
    return YellowMain;
  }

  if (days > 0) {
    return GreenMain;
  }

  return RedMain;
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
