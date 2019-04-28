import 'package:meta/meta.dart';

import './flower.dart';

@immutable
class AppState {
  final List<Flower> flowers;
  final bool isFetchingData;
  final bool isCreatingFlower;
  final bool isFirstTimeUser;

  AppState({
    this.flowers,
    this.isFetchingData,
    this.isCreatingFlower = false,
    this.isFirstTimeUser = false,
  });
}
