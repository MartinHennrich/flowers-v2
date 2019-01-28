import 'package:flutter/material.dart';

import '../flower.dart';
import '../constants/enums.dart';
import '../utils/soilMoisture.dart';
import '../utils/waterAmount.dart';
import '../utils/notifications.dart';

List<Flower> getFlowersThatHasBeenWatered(List<Flower> flowers) {
  DateTime dateTime = DateTime.now();
  List<Flower> flowersThatHasBeenWaterd = [];
  flowers.forEach((flower){
    int lastWaterDay = flower.reminders.water.lastTime.day;
    int lastWaterMonth = flower.reminders.water.lastTime.month;

    if (lastWaterDay == dateTime.day && lastWaterMonth == dateTime.month) {
      flowersThatHasBeenWaterd.add(flower);
    }
  });

  return flowersThatHasBeenWaterd;
}

List<Flower> getFlowersThatNeedWater(List<Flower> flowers) {
  DateTime dateTime = DateTime.now();
  List<Flower> flowersThatNeedWater = [];
  flowers.forEach((flower){
    int lastWaterDay = flower.reminders.water.lastTime.day;
    int lastWaterMonth = flower.reminders.water.lastTime.month;

    if (lastWaterDay == dateTime.day && lastWaterMonth == dateTime.month) {
      return;
    }

    int waterDay = flower.reminders.water.nextTime.day;
    int waterMonth = flower.reminders.water.nextTime.month;

    if (waterDay <= dateTime.day && waterMonth == dateTime.month) {
      flowersThatNeedWater.add(flower);
    }
  });

  DateTime today = DateTime.now();
  flowersThatNeedWater.sort((a, b) {
    int aDiffDays = a.reminders.water.nextTime.difference(today).inDays;
    int bDiffDays = b.reminders.water.nextTime.difference(today).inDays;
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

  rescheduleNotification(
    flower.key,
    flower.name,
    flower.reminders.water.nextTime
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

  int nextWaterDaysFromSoil = soilMoistureToNextWaterDays(soilMoisture);
  int nextWaterDaysFromAmount = waterAmountToNextWaterDays(waterAmount);
  int nextWaterDays = nextWaterDaysFromSoil + nextWaterDaysFromAmount;
  WaterTime waterTime = WaterTime(
    waterAmount: waterAmount,
    soilMoisture: soilMoisture,
    wateredTime: wateredTime
  );

  if (nextWaterDays < 0) {
    nextWaterDays = 1;
  } else {
    nextWaterDays += flower.reminders.water.interval;
  }

  flower.reminders.water.lastTime = wateredTime;
  flower.addWaterTime(waterTime);

  DateTime nextWaterTime = DateTime.now().add(Duration(days: nextWaterDays));
  flower.reminders.water.nextTime = nextWaterTime;

  scheduleNotification(
    flower.key,
    flower.name,
    flower.reminders.water.nextTime
  );

  return WateredFlower(
    flower,
    waterTime
  );
}
