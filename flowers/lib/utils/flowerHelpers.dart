import 'package:flutter/material.dart';

import '../flower.dart';

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
