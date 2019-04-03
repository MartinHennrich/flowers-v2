import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/enums.dart';
import '../flower.dart';
import '../presentation/custom_icons_icons.dart';
import '../reminders.dart';
import '../utils/notifications.dart';
import './notifications.dart';

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
    return ReminderBlueMain;
  }

  if (type == ReminderType.Fertilize) {
    return BrownMain;
  }

  if (type == ReminderType.Rotate) {
    return ReminderPurpleMain;
  }

  return RedMain;
}


Flower runActionOnReminder(Flower flower, Reminder reminder){
  DateTime rotateTime = DateTime.now();

  reminder.lastTime = rotateTime;
  DateTime nextTime = DateTime.now().add(Duration(days: reminder.interval));
  reminder.nextTime = nextTime;

  flower.reminders.updateReminder(reminder);
  scheduleNotificationForReminder(
    flower.name,
    reminder
  );

  return flower;
}

Flower postponeReminder(Flower flower, Reminder reminder, int nextDays) {
  if (nextDays <= 0) {
    nextDays = 1;
  }

  DateTime nextTime = DateTime.now().add(Duration(days: nextDays));
  reminder.nextTime = nextTime;

  flower.reminders.updateReminder(reminder);
  scheduleNotificationForReminder(
    flower.name,
    reminder
  );

  return flower;
}

class WateredFlower {
  Flower flower;
  WaterTime waterTime;
  WateredFlower(
    this.flower,
    this.waterTime
  );
}

WateredFlower waterActionReminder(Flower flower, WaterAmount waterAmount, SoilMoisture soilMoisture) {
  Flower updatedFlower = runActionOnReminder(flower, flower.reminders.water);

  WaterTime waterTime = WaterTime(
    waterAmount: waterAmount,
    soilMoisture: soilMoisture,
    wateredTime: updatedFlower.reminders.water.lastTime
  );

  flower.addWaterTime(waterTime);
  return WateredFlower(
    flower,
    waterTime
  );
}

