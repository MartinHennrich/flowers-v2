
import './constants/enums.dart';

class WaterTime {
  DateTime wateredTime;
  SoilMoisture soilMoisture;
  WaterAmount waterAmount;

  WaterTime({
    this.wateredTime,
    this.soilMoisture,
    this.waterAmount,
  });
}

class Flower {
  String name;
  String imageUrl;
  String key;
  int waterInterval;
  DateTime lastTimeWatered;
  DateTime nextWaterTime;
  List<WaterTime> waterTimes = [];

  Flower({
    this.name,
    this.lastTimeWatered,
    this.nextWaterTime,
    this.imageUrl,
    this.key,
    this.waterInterval,
  });

  void setWaterTimes(List<WaterTime> waterTimes) {
    this.waterTimes = waterTimes;
  }

  void addWaterTime(WaterTime waterTime) {
    var tmp = this.waterTimes;
    if (tmp.length > 0) {
      tmp.add(waterTime);
      this.waterTimes = tmp;
    }
  }
}
