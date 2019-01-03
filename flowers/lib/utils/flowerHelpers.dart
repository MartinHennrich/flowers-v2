import 'package:flutter/material.dart';

import '../flower.dart';

List<Flower> getFlowersThatHasBeenWatered(List<Flower> flowers) {
  DateTime dateTime = DateTime.now();
  List<Flower> flowersThatHasBeenWaterd = [];
  flowers.forEach((flower){
    int lastWaterDay = flower.lastTimeWatered.day;
    int lastWaterMonth = flower.lastTimeWatered.month;

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
    int lastWaterDay = flower.lastTimeWatered.day;
    int lastWaterMonth = flower.lastTimeWatered.month;

    if (lastWaterDay == dateTime.day && lastWaterMonth == dateTime.month) {
      return;
    }

    int waterDay = flower.nextWaterTime.day;
    int waterMonth = flower.nextWaterTime.month;

    if (waterDay == dateTime.day && waterMonth == dateTime.month) {
      flowersThatNeedWater.add(flower);
    }
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
