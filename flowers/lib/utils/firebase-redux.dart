import 'package:firebase_database/firebase_database.dart';

import '../flower.dart';
import '../store.dart';
import '../actions/actions.dart';
import '../constants/enums.dart';
import '../utils/firebase.dart';

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

    flowers.add(
      Flower(
        name: name,
        imageUrl: imageUrl,
        lastTimeWatered: lastTimeWatered,
        nextWaterTime: nextWaterTime,
        key: k,
        waterInterval: waterInterval
      )
    );
  });

  return flowers;
}

void addSnapshotToRedux(DataSnapshot snapshot) {
  List<Flower> flowers = snapshotToFlowers(snapshot);
  AppStore.dispatch(AddFlowersAction(flowers));
}

// TODO: make this % based in the future
int postponeSoilMoistureToDays(SoilMoisture soilMoisture) {
  switch (soilMoisture) {
    case SoilMoisture.Soil50:
    case SoilMoisture.Soil25:
    case SoilMoisture.Soil0:
      return 1;
    case SoilMoisture.Soil75:
      return 2;
    case SoilMoisture.Soil100:
      return 3;
    default:
      return 0;
  }
}

// TODO: make this % based in the future
int soilMoistureToNextWaterDays(SoilMoisture soilMoisture) {
  switch (soilMoisture) {
    case SoilMoisture.Soil0:
      return -2;
    case SoilMoisture.Soil25:
      return -1;
    case SoilMoisture.Soil50:
      return 0;
    case SoilMoisture.Soil75:
      return 1;
    case SoilMoisture.Soil100:
      return 2;
    default:
      return 0;
  }
}

// TODO: make this % based in the future
int waterAmountToNextWaterDays(WaterAmount waterAmount) {
  switch (waterAmount) {
    case WaterAmount.Small:
      return -1;
    case WaterAmount.Normal:
      return 0;
    case WaterAmount.Lots:
      return 1;
    default:
  }
}

Future<void> postponeWatering(Flower flower, SoilMoisture soilMoisture) {
  int nextWaterDays = postponeSoilMoistureToDays(soilMoisture);
  if (nextWaterDays <= 0) {
    nextWaterDays = 1;
  } else {
    nextWaterDays += flower.waterInterval;
  }

  DateTime nextWaterTime = DateTime.now().add(Duration(days: nextWaterDays));
  flower.nextWaterTime = nextWaterTime;

  AppStore.dispatch(UpdateFlowersAction(flower));

  return database.postponeWatering(flower);
}

Future<void> waterFlower(Flower flower, WaterAmount waterAmount, SoilMoisture soilMoisture) {
  DateTime wateredTime = DateTime.now();

  int nextWaterDaysFromSoil = soilMoistureToNextWaterDays(soilMoisture);
  int nextWaterDaysFromAmount = waterAmountToNextWaterDays(waterAmount);
  int nextWaterDays = nextWaterDaysFromSoil + nextWaterDaysFromAmount;

  if (nextWaterDays <= 0) {
    nextWaterDays = 1;
  } else {
    nextWaterDays += flower.waterInterval;
  }

  flower.lastTimeWatered = wateredTime;

  DateTime nextWaterTime = DateTime.now().add(Duration(days: nextWaterDays));
  flower.nextWaterTime = nextWaterTime;

  AppStore.dispatch(UpdateFlowersAction(flower));

  return database.waterFlower(flower);
}
