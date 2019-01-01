import 'package:meta/meta.dart';

import './flower.dart';

@immutable
class AppState {
  List<Flower> flowers;

  AppState({
    this.flowers
  });
}
