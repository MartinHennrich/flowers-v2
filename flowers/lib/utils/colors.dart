import 'dart:math';

import 'package:flutter/material.dart';

import '../constants/colors.dart';
import './dateHelpers.dart';
import '../flower.dart';
import '../reminders.dart';

LinearGradient getColorGradientBasedOnTime(DateTime time, DateTime lastTime) {
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

Color getColorBasedOnTime(DateTime time, DateTime lastTime) {
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

LinearGradient getColorGradientForFlower(Flower flower) {
  List<Reminder> r = flower.reminders.getRemindersThatNeedAction(DateTime.now());
  if (r.length == 0) {
    var p = flower.reminders.getCompletedReminders(DateTime.now());
    if (p.length > 0) {
      return BlueGradient;
    }
  }

  Reminder clostToDate = flower.reminders.getClosestDate(DateTime.now());
  if (clostToDate == null) {
    return GreenGradient;
  }

  return getColorGradientBasedOnTime(clostToDate.nextTime, clostToDate.lastTime);
}

Color getColorForFlower(Flower flower) {

  List<Reminder> r = flower.reminders.getRemindersThatNeedAction(DateTime.now());
  if (r.length == 0) {
    var p = flower.reminders.getCompletedReminders(DateTime.now());
    if (p.length > 0) {
      return BlueMain;
    }
  }

  Reminder clostToDate = flower.reminders.getClosestDate(DateTime.now());
  if (clostToDate == null) {
    return GreenMain;
  }

  return getColorBasedOnTime(clostToDate.nextTime, clostToDate.lastTime);
}

Color getRandomLabelColor() {
  final Random random = Random();
  return labelColors[random.nextInt(labelColors.length)];
}
