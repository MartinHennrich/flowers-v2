import 'package:firebase_database/firebase_database.dart';

import '../flower.dart';
import '../store.dart';
import '../actions/actions.dart';
import '../constants/enums.dart';
import '../utils/firebase.dart';

int soilMoistureToInt(SoilMoisture value) {
  switch (value) {
    case SoilMoisture.Soil0:
      return 0;
    case  SoilMoisture.Soil25:
      return 25;
    case  SoilMoisture.Soil50:
      return 50;
    case  SoilMoisture.Soil75:
      return 75;
    case SoilMoisture.Soil100:
      return 100;
    default:
      return 25;
  }
}

int waterAmountToInt(WaterAmount value) {
  switch (value) {
    case WaterAmount.Small:
      return 0;
    case WaterAmount.Normal:
      return 1;
    case WaterAmount.Lots:
      return 2;
    default:
      return 1;
  }
}

SoilMoisture intToSoilMoisture(int value) {
  switch (value) {
    case 0:
      return SoilMoisture.Soil0;
    case 25:
      return SoilMoisture.Soil25;
    case 50:
      return SoilMoisture.Soil50;
    case 75:
      return SoilMoisture.Soil75;
    case 100:
      return SoilMoisture.Soil100;
    default:
      return SoilMoisture.Soil25;
  }
}

WaterAmount intToWaterAmount(int value) {
  switch (value) {
    case 0:
      return WaterAmount.Small;
    case 1:
      return WaterAmount.Normal;
    case 2:
      return WaterAmount.Lots;
    default:
      return WaterAmount.Normal;
  }
}

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

// TODO: make this % based in the future
int postponeSoilMoistureToDays(SoilMoisture soilMoisture) {
  switch (soilMoisture) {
    case SoilMoisture.Soil25:
    case SoilMoisture.Soil0:
      return 0;
    case SoilMoisture.Soil50:
      return 1;
    case SoilMoisture.Soil75:
      return 1;
    case SoilMoisture.Soil100:
      return 2;
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
  WaterTime waterTime = WaterTime(
    waterAmount: waterAmount,
    soilMoisture: soilMoisture,
    wateredTime: wateredTime
  );

  if (nextWaterDays <= 0) {
    nextWaterDays = 1;
  } else {
    nextWaterDays += flower.waterInterval;
  }

  flower.lastTimeWatered = wateredTime;
  flower.waterTimes.add(waterTime);

  DateTime nextWaterTime = DateTime.now().add(Duration(days: nextWaterDays));
  flower.nextWaterTime = nextWaterTime;

  AppStore.dispatch(UpdateFlowersAction(flower));

  return database.waterFlower(flower, waterTime);
}
