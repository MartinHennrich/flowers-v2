import 'package:flutter/material.dart';
import '../constants/colors.dart';

LinearGradient getColorBasedOnTime(DateTime time) {
  DateTime today = DateTime.now();
  Duration difference = time.difference(today);
  int days = difference.inDays;

  if (days == 0) {
    return YellowGradient;
  }

  if (days > 0) {
    return GreenGradient;
  }

  return RedGradient;
}

Color getColorBasedOnTime2(DateTime time, DateTime lastTime) {
  DateTime today = DateTime.now();
  Duration difference = time.difference(today);
  int days = difference.inDays;

  if (today.day == lastTime.day && lastTime.month == today.month) {
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
