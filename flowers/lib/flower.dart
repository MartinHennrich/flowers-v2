import 'package:flutter/material.dart';

import './constants/enums.dart';
import 'reminders.dart';

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

class Label {
  String value;
  Color color;

  Label({
    this.value,
    this.color
  });
}

class Flower {
  String name;
  String imageUrl;
  String imageId;
  String key;
  Reminders reminders;
  List<Label> labels = [];
  List<WaterTime> waterTimes = [];

  Flower({
    this.name,
    this.imageUrl,
    this.imageId,
    this.key,
    this.reminders,
    this.labels,
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

  void setLables(List<Label> labels) {
    this.labels = labels;
  }

  void addLable(Label label) {
    var tmp = this.labels;
    tmp.add(label);
    this.labels = tmp;
  }

  void removeLable(Label label) {
    var tmp = this.labels;
    if (tmp.length > 0) {
      tmp.removeWhere((flowerLabel) => flowerLabel.value == label.value);
      this.labels = tmp;
    }
  }

  Map<String, dynamic> toLabelsFirebaseObject() {
    Map<String, dynamic> lablesMap = {};

    labels.forEach((label) {
      lablesMap[label.value] = {
        'value': label.value,
        'color': label.color.value
      };
    });

    return lablesMap;
  }
}
