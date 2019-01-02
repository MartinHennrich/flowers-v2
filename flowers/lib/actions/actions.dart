import '../flower.dart';

class AddFlowerAction {
  Flower flower;
  AddFlowerAction(this.flower);
}

class AddFlowersAction {
  List<Flower> flowers;
  AddFlowersAction(this.flowers);
}

enum FetchingData {
  Completed,
  Fetching
}
