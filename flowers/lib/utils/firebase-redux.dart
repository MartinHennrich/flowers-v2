import 'dart:async';
import 'package:firebase_database/firebase_database.dart';

import '../flower.dart';
import '../reminders.dart';
import '../store.dart';
import '../actions/actions.dart';
import '../constants/enums.dart';
import '../utils/reminderHelpers.dart' as reminderHelpers;
import '../utils/firebase.dart';
import '../utils/waterAmount.dart';
import '../utils/soilMoisture.dart';

List<WaterTime> snapshotToWaterTime(dynamic waterTimesSnapshot) {
  List<WaterTime> waterTimes = [];
  var waterTimesMap = Map.from(waterTimesSnapshot.value);


  waterTimesMap.forEach((k, value){
    DateTime wateredTime = DateTime.parse(value['time']);
    SoilMoisture soilMoisture = intToSoilMoisture(value['soil']);
    WaterAmount waterAmount = intToWaterAmount(value['amount']);

    waterTimes.add(
      WaterTime(
        soilMoisture: soilMoisture,
        wateredTime: wateredTime,
        waterAmount: waterAmount
      )
    );
  });

  return waterTimes;
}

Reminders snapshotToReminders(dynamic remindersSnapshot) {
  Reminder waterReminder;
  Reminder fertilizeReminder;
  Reminder rotateReminder;

  if (remindersSnapshot == null) {
    return Reminders();
  }

  var remindersMap = Map.from(remindersSnapshot);

  remindersMap.forEach((key, value) {

    switch (key) {
      case 'water':
        waterReminder = Reminder(
          lastTime: DateTime.parse(value['lastTime']),
          nextTime: DateTime.parse(value['nextTime']),
          interval: value['interval'],
          timeOfDayForNotification: DateTime.parse(value['timeOfDayForNotification']),
          key: key,
          type: ReminderType.Water,
          isActive: value['isActive']
        );
        break;
      case 'fertilize':
        fertilizeReminder = Reminder(
          lastTime: DateTime.parse(value['lastTime']),
          nextTime: DateTime.parse(value['nextTime']),
          interval: value['interval'],
          timeOfDayForNotification: DateTime.parse(value['timeOfDayForNotification']),
          key: key,
          type: ReminderType.Fertilize,
          isActive: value['isActive']
        );
        break;
      case 'rotate':
        rotateReminder = Reminder(
          lastTime: DateTime.parse(value['lastTime']),
          nextTime: DateTime.parse(value['nextTime']),
          interval: value['interval'],
          timeOfDayForNotification: DateTime.parse(value['timeOfDayForNotification']),
          key: key,
          type: ReminderType.Rotate,
          isActive: value['isActive']
        );
        break;
      default:
    }
  });

  return Reminders(
    water: waterReminder,
    fertilize: fertilizeReminder,
    rotate: rotateReminder,
  );
}

List<Flower> snapshotToFlowers(DataSnapshot snapshot) {
  var databaseFlowers = snapshot.value['flowers'];
  var flowersMap = Map.from(databaseFlowers);
  List<Flower> flowers = [];

  flowersMap.forEach((k, value) {
    if (k == '__none__') {
      return;
    }

    String name = value['name'];
    String imageUrl = value['image'];
    String imageId = value['imageId'];
    Reminders reminders = snapshotToReminders(value['reminders']);

    flowers.add(
      Flower(
        name: name,
        imageUrl: imageUrl,
        imageId: imageId,
        reminders: reminders,
        key: k,
      )
    );
  });

  return flowers;
}

void addSnapshotToRedux(DataSnapshot snapshot) {
  List<Flower> flowers = snapshotToFlowers(snapshot);
  AppStore.dispatch(AddFlowersAction(flowers));
}

Future<void> postponeWatering(Flower flower, SoilMoisture soilMoisture) {
  int nextWaterDays = postponeSoilMoistureToDays(soilMoisture);
  Flower postponedFlower = reminderHelpers.postponeReminder(flower, flower.reminders.water, nextWaterDays);

  AppStore.dispatch(UpdateFlowerAction(postponedFlower));
  return database.postponeWatering(postponedFlower);
}

Future<void> waterFlower(Flower flower, WaterAmount waterAmount, SoilMoisture soilMoisture) {
  reminderHelpers.WateredFlower wateredFlower = reminderHelpers.waterActionReminder(flower, waterAmount, soilMoisture);

  AppStore.dispatch(UpdateFlowerAction(wateredFlower.flower));
  return database.waterFlower(wateredFlower.flower, wateredFlower.waterTime);
}

Future<void> rotateFlower(Flower flower) {
  Flower rotatedFlower = reminderHelpers.runActionOnReminder(flower, flower.reminders.rotate);
  AppStore.dispatch(UpdateFlowerAction(rotatedFlower));

  return database.updateAllReminders(rotatedFlower);
}

Future<void> postponeRotate(Flower flower, int days) {
  Flower posteponedRotationFlower = reminderHelpers.postponeReminder(flower, flower.reminders.rotate, days);
  AppStore.dispatch(UpdateFlowerAction(posteponedRotationFlower));

  return database.postpone(flower, flower.reminders.rotate);
}

Future<void> fertilizeFlower(Flower flower) {
  Flower fertilizeFlower = reminderHelpers.runActionOnReminder(flower, flower.reminders.fertilize);
  AppStore.dispatch(UpdateFlowerAction(fertilizeFlower));

  return database.updateAllReminders(fertilizeFlower);
}

Future<void> postponeFertilize(Flower flower, int days) {
  Flower posteponedfertilizeFlower = reminderHelpers.postponeReminder(flower, flower.reminders.fertilize, days);
  AppStore.dispatch(UpdateFlowerAction(posteponedfertilizeFlower));

  return database.postpone(flower, flower.reminders.fertilize);
}
