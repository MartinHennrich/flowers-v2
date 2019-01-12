import '../flower.dart';

class AddFlowerAction {
  Flower flower;
  AddFlowerAction(this.flower);
}

class AddFlowersAction {
  List<Flower> flowers;
  AddFlowersAction(this.flowers);
}

class UpdateFlowerAction {
  Flower flower;

  UpdateFlowerAction(this.flower);
}

enum FetchingData {
  Completed,
  Fetching
}

enum CreatingFlower {
  Creating,
  Available
}
