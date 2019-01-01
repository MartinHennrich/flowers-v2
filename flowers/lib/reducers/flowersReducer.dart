import "../actions/actions.dart";

import "../flower.dart";

List<Flower> flowersReducer(List<Flower> state, dynamic action) {
  if (action is AddFlowerAction) {
    state.add(action.flower);
    return state;
  }
  return state;
}
