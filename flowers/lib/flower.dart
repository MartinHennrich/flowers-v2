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

  List<Reminder> getRemindersAsList({bool sortActive = false}) {
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

    Iterable<Reminder> items = list.expand((i) => [i]);

    if (sortActive) {
      return items
        .where((item) => item.isActive)
        .toList();
    }
    return items.toList();
  }

  List<Reminder> getRemindersThatNeedAction(DateTime time) {
    List<Reminder> activeReminders = getRemindersAsList(sortActive: true);

    if (activeReminders.length == 0) {
      return [];
    }

    return activeReminders.where((reminder) {
      if (reminder.lastTime.day == time.day && reminder.lastTime.month == time.month) {
        return false;
      }

      if (reminder.nextTime.day <= time.day && reminder.nextTime.month <= time.month) {
        return true;
      }
      return false;
    }).toList();
  }

  List<Reminder> getCompletedReminders(DateTime time) {
    List<Reminder> activeReminders = getRemindersAsList(sortActive: true);

    if (activeReminders.length == 0) {
      return [];
    }

    return activeReminders.where((reminder) {
      if (reminder.lastTime.day == time.day && reminder.lastTime.month == time.month) {
        return true;
      }

      return false;
    }).toList();
  }

  bool isAllRemindersCompleted(DateTime time) {
    List<Reminder> activeReminders = getRemindersAsList(sortActive: true);
    List<Reminder> completedReminders = getCompletedReminders(time);

    List<Reminder> actionableReminders = activeReminders.where((reminder) {
      if (reminder.lastTime.day == time.day && reminder.lastTime.month == time.month) {
        return true;
      }

      return false;
    }).toList();

    if (actionableReminders == null || completedReminders == null ||
      actionableReminders.length == 0 ||
      completedReminders.length == 0
    ) {
      return false;
    }

    return actionableReminders.length == completedReminders.length;
  }

  Reminders removeReminderByType(ReminderType type) {
    switch (type) {
      case ReminderType.Water:
        water = null;
      break;
      case ReminderType.Fertilize:
        fertilize = null;
      break;
      case ReminderType.Rotate:
        rotate = null;
      break;
      default:
      break;
    }

    return Reminders(
      water: water,
      fertilize: fertilize,
      rotate: rotate
    );
  }

  Reminders updateReminder(Reminder reminder) {
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

    return Reminders(
      water: water,
      fertilize: fertilize,
      rotate: rotate
    );
  }

  // TODO: store all dates with notification time on them
  int _compare(Reminder a, Reminder b, DateTime time) {
    Duration aDiffDays = a.nextTime.difference(time);
    Duration bDiffDays = b.nextTime.difference(time);

    int diff = aDiffDays.compareTo(bDiffDays);

    if (diff < 0) {
      return -1;
    }

    if (diff > 0) {
      return 1;
    }

    return 0;
  }

  Reminder getClosestDate(DateTime time) {
    List<Reminder> reminders = getRemindersAsList(sortActive: true);

    if (reminders.length == 1) {
      return reminders[0];
    } else if (reminders.length == 0) {
      return null;
    }

    reminders.sort((a, b) => _compare(a, b, time));

    return reminders[0];
  }

  Reminders clone() {
    return Reminders(
      rotate: rotate,
      fertilize: fertilize,
      water: water
    );
  }

  Map<String, dynamic> toFirebaseObject() {
    Map<String, dynamic> obj = {};
    if (water != null && water.isActive) {
      obj['water'] = {
        'interval': water.interval,
        'lastTime': water.lastTime.toIso8601String(),
        'nextTime': water.nextTime.toIso8601String(),
        'timeOfDayForNotification': water.timeOfDayForNotification.toIso8601String(),
        'isActive': water.isActive
      };
    }
    if (fertilize != null && fertilize.isActive) {
      obj['fertilize'] = {
        'interval': fertilize.interval,
        'lastTime': fertilize.lastTime.toIso8601String(),
        'nextTime': fertilize.nextTime.toIso8601String(),
        'timeOfDayForNotification': fertilize.timeOfDayForNotification.toIso8601String(),
        'isActive': fertilize.isActive
      };
    }
    if (rotate != null && rotate.isActive) {
      obj['rotate'] = {
        'interval': rotate.interval,
        'lastTime': rotate.lastTime.toIso8601String(),
        'nextTime': rotate.nextTime.toIso8601String(),
        'timeOfDayForNotification': rotate.timeOfDayForNotification.toIso8601String(),
        'isActive': rotate.isActive
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
