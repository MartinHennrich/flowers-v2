import 'package:meta/meta.dart';

import './flower.dart';

@immutable
class AppState {
  List<Flower> flowers;
  bool isFetchingData;
  bool isCreatingFlower;

  AppState({
    this.flowers,
    this.isFetchingData,
    this.isCreatingFlower
  });
}
