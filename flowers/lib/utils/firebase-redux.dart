import 'package:firebase_database/firebase_database.dart';

import '../flower.dart';
import '../store.dart';
import '../actions/actions.dart';

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

    flowers.add(
      Flower(
        name: name,
        imageUrl: imageUrl,
        lastTimeWatered: lastTimeWatered,
        nextWaterTime: nextWaterTime,
        key: k
      )
    );
  });

  return flowers;
}

void addSnapshotToRedux(DataSnapshot snapshot) {
  List<Flower> flowers = snapshotToFlowers(snapshot);
  AppStore.dispatch(AddFlowersAction(flowers));
}
