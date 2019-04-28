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

class DeleteFlowerAction {
  Flower flower;

  DeleteFlowerAction(this.flower);
}

enum FetchingData {
  Completed,
  Fetching,
  Error
}

enum CreatingFlower {
  Creating,
  Available
}

enum IsFirstTimeUser {
  Yes,
  No
}
