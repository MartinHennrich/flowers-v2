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

enum ReminderType {
  Water,
  Rotate,
  Fertilize,
}

class Reminder {
  String key;
  bool isActive;
  ReminderType type;
  int interval;
  DateTime lastTime;
  DateTime nextTime;
  DateTime timeOfDayForNotification = DateTime(2019, 1, 1, 8, 0);

  Reminder({
    this.key,
    this.interval,
    this.lastTime,
    this.nextTime,
    this.timeOfDayForNotification,
    this.type,
    this.isActive = true,
  });
}

class Reminders {
  Reminder water;
  Reminder fertilize;
  Reminder rotate;

  Reminders({
    this.water,
    this.fertilize,
    this.rotate
  });

  List<Reminder> getRemindersAsList() {
    List<Reminder> list = [];

    if (water != null) {
      list.add(water);
    }

    if (fertilize != null) {
      list.add(fertilize);
    }

    if (rotate != null) {
      list.add(rotate);
    }

    return list.expand((i) => [i]).toList();
  }

  void updateReminder(Reminder reminder) {
    switch (reminder.type) {
      case ReminderType.Water:
        water = reminder;
      break;
      case ReminderType.Fertilize:
        fertilize = reminder;
      break;
      case ReminderType.Rotate:
        rotate = reminder;
      break;
      default:
      break;
    }
  }

  Map<String, dynamic> toFirebaseObject() {
    Map<String, dynamic> obj = {};
    if (water != null && water.isActive) {
      obj['water'] = {
        'interval': water.interval,
        'lastTime': water.lastTime.toIso8601String(),
        'nextTime': water.nextTime.toIso8601String(),
        'timeOfDayForNotification': water.timeOfDayForNotification.toIso8601String()
      };
    }
    if (fertilize != null && fertilize.isActive) {
      obj['fertilize'] = {
        'interval': fertilize.interval,
        'lastTime': fertilize.lastTime.toIso8601String(),
        'nextTime': fertilize.nextTime.toIso8601String(),
        'timeOfDayForNotification': fertilize.timeOfDayForNotification.toIso8601String()
      };
    }
    if (rotate != null && rotate.isActive) {
      obj['rotate'] = {
        'interval': rotate.interval,
        'lastTime': rotate.lastTime.toIso8601String(),
        'nextTime': rotate.nextTime.toIso8601String(),
        'timeOfDayForNotification': rotate.timeOfDayForNotification.toIso8601String()
      };
    }

    return obj;
  }
}

class Flower {
  String name;
  String imageUrl;
  String imageId;
  String key;
  Reminders reminders;
  List<WaterTime> waterTimes = [];

  Flower({
    this.name,
    this.imageUrl,
    this.imageId,
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
