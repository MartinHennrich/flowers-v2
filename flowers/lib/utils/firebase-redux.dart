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

  if (waterTimesSnapshot == null) {
    return waterTimes;
  }

  var waterTimesMap = Map.from(waterTimesSnapshot);

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
    DateTime lastTimeWatered = DateTime.parse(value['lastTimeWatered']);
    DateTime nextWaterTime = DateTime.parse(value['nextWaterTime']);
    int waterInterval = value['waterInterval'];
    List<WaterTime> waterTimes = snapshotToWaterTime(value['waterTimes']);
    flowers.add(
      Flower(
        name: name,
        imageUrl: imageUrl,
        lastTimeWatered: lastTimeWatered,
        nextWaterTime: nextWaterTime,
        key: k,
        waterInterval: waterInterval,
        waterTimes: waterTimes
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
