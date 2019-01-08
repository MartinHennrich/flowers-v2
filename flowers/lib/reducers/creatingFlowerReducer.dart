import "../actions/actions.dart";

bool isCreatingFlowerReducer(bool state, dynamic action) {
  if (action == CreatingFlower.Available) {
    return false;
  }
  if (action == CreatingFlower.Creating) {
    return true;
  }
  return state;
}
