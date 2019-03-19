import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../flower.dart';
import '../constants/enums.dart';
import '../utils/soilMoisture.dart';
import '../utils/notifications.dart';

List<Flower> getFlowersThatHasBeenCompleted(List<Flower> flowers) {
  DateTime timeNow = DateTime.now();
  List<Flower> flowersThatHasBeenCompleted = [];
  flowers.forEach((flower){
    if (flower.reminders.isAllRemindersCompletedForDate(timeNow)) {
      flowersThatHasBeenCompleted.add(flower);
    }
  });

  return flowersThatHasBeenCompleted;
}

List<Flower> getFlowersThatNeedAction(List<Flower> flowers) {
  DateTime timeNow = DateTime.now();
  List<Flower> flowersThatNeedWater = [];
  flowers.forEach((flower) {
    if (flower.reminders.getRemindersThatNeedAction(timeNow).length > 0) {
      flowersThatNeedWater.add(flower);
    }
  });

  flowersThatNeedWater.sort((a, b) {
    var aClosest = a.reminders.getClosestDate(timeNow);
    var bClosest = b.reminders.getClosestDate(timeNow);

    int aDiffDays = aClosest.nextTime.difference(timeNow).inHours;
    int bDiffDays = bClosest.nextTime.difference(timeNow).inHours;

    return aDiffDays.compareTo(bDiffDays);
  });

  return flowersThatNeedWater;
}

List<List<Widget>> pairFlowers(List<Widget> inputList) {
  List<List<Widget>> pairedList = [];
  int skips = 0;
  inputList.forEach((value) {
    var value = inputList.skip(skips).take(2);
    skips += 2;
    if (value.length > 0) {
    	pairedList.add(value.toList());
    }
  });

  return pairedList;
}

Flower postponeWatering(Flower flower, SoilMoisture soilMoisture) {
  int nextWaterDays = postponeSoilMoistureToDays(soilMoisture);
  if (nextWaterDays <= 0) {
    nextWaterDays = 1;
  }

  DateTime nextWaterTime = DateTime.now().add(Duration(days: nextWaterDays));
  flower.reminders.water.nextTime = nextWaterTime;

  scheduleWaterNotification(
    flower.key,
    flower.name,
    flower.reminders.water.nextTime,
    flower.reminders.water.timeOfDayForNotification
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

WateredFlower waterFlower(Flower flower, WaterAmount waterAmount, SoilMoisture soilMoisture) {
  DateTime wateredTime = DateTime.now();
  WaterTime waterTime = WaterTime(
    waterAmount: waterAmount,
    soilMoisture: soilMoisture,
    wateredTime: wateredTime
  );

  flower.reminders.water.lastTime = wateredTime;
  flower.addWaterTime(waterTime);

  DateTime nextWaterTime = DateTime.now().add(Duration(days: flower.reminders.water.interval));
  flower.reminders.water.nextTime = nextWaterTime;

  scheduleWaterNotification(
    flower.key,
    flower.name,
    flower.reminders.water.nextTime,
    flower.reminders.water.timeOfDayForNotification
  );

  return WateredFlower(
    flower,
    waterTime
  );
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
