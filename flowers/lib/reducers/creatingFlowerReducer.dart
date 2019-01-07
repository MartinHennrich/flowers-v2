import "../actions/actions.dart";

bool creatingFlowerReducer(bool state, dynamic action) {
  if (action == CreatingFlower.Available) {
    return false;
  }
  if (action == CreatingFlower.Creating) {
    return true;
  }
  return state;
}
