import 'package:flutter/material.dart';
import '../constants/colors.dart';

LinearGradient getColorBasedOnTime(DateTime time) {
  DateTime today = DateTime.now();
  Duration difference = time.difference(today);
  int days = difference.inDays;

  if (days < -2) {
    return RedPinkGradient;
  }

  switch (days) {
    case 0:
      return GreenBlueGradient;
    case -1:
      return YellowGradient;
    case -2:
      return RedPinkGradient;
    default:
      return GreenBlueGradient;
  }
}
