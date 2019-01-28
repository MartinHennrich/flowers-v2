
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

class Reminder {
  String key;
  int interval;
  DateTime lastTime;
  DateTime nextTime;

  Reminder({
    this.key,
    this.interval,
    this.lastTime,
    this.nextTime,
  });
}

class Reminders {
  Reminder water;

  Reminders({
    this.water,
  });

  Map<String, dynamic> toFirebaseObject() {
    Map<String, dynamic> obj = {};
    if (water != null) {
      obj['water'] = {
        'interval': water.interval,
        'lastTime': water.lastTime.toIso8601String(),
        'nextTime': water.nextTime.toIso8601String(),
      };
    }

    return obj;
  }
}

class Flower {
  String name;
  String imageUrl;
  String key;
  Reminders reminders;
  List<WaterTime> waterTimes = [];

  Flower({
    this.name,
    this.imageUrl,
    this.key,
    this.reminders
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
