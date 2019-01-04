
class Flower {
  String name;
  String imageUrl;
  String key;
  int waterInterval;
  DateTime lastTimeWatered;
  DateTime nextWaterTime;

  Flower({
    this.name,
    this.lastTimeWatered,
    this.nextWaterTime,
    this.imageUrl,
    this.key,
    this.waterInterval
  });
}
