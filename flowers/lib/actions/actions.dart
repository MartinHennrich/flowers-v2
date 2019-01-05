import '../flower.dart';
import '../constants/enums.dart';

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
