import "../actions/actions.dart";

bool isFetchingDataReducer(bool state, dynamic action) {
  if (action == FetchingData.Completed) {
    return false;
  }
  if (action == FetchingData.Fetching) {
    return true;
  }
  if (action == FetchingData.Error) {
    return null;
  }
  return state;
}
