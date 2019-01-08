import 'package:meta/meta.dart';

import './flower.dart';

@immutable
class AppState {
  final List<Flower> flowers;
  final bool isFetchingData;
  final bool isCreatingFlower;

  AppState({
    this.flowers,
    this.isFetchingData,
    this.isCreatingFlower = false
  });
}
