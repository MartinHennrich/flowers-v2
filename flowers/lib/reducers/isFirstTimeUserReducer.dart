import "../actions/actions.dart";

bool isFirstTimeUserReducer(bool state, dynamic action) {
  if (action == IsFirstTimeUser.Yes) {
    return true;
  }
  if (action == IsFirstTimeUser.No) {
    return false;
  }
  return state;
}
