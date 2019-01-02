import 'package:meta/meta.dart';

import './flower.dart';

@immutable
class AppState {
  List<Flower> flowers;
  bool isFetchingData;

  AppState({
    this.flowers,
    this.isFetchingData
  });
}
