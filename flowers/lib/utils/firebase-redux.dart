import 'package:firebase_database/firebase_database.dart';

import '../flower.dart';
import '../store.dart';
import '../actions/actions.dart';
import '../constants/enums.dart';
import '../utils/flowerHelpers.dart' as flowerHelpers;
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
        );
      break;
      default:
    }
  });

  return Reminders(
    water: waterReminder,
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
  Flower postponedFlower = flowerHelpers.postponeWatering(flower, soilMoisture);

  AppStore.dispatch(UpdateFlowerAction(postponedFlower));
  return database.postponeWatering(postponedFlower);
}

Future<void> waterFlower(Flower flower, WaterAmount waterAmount, SoilMoisture soilMoisture) {
  flowerHelpers.WateredFlower wateredFlower = flowerHelpers.waterFlower(flower, waterAmount, soilMoisture);

  AppStore.dispatch(UpdateFlowerAction(wateredFlower.flower));
  return database.waterFlower(wateredFlower.flower, wateredFlower.waterTime);
}
