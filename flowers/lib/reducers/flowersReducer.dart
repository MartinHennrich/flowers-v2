import "../actions/actions.dart";

import "../flower.dart";

List<Flower> flowersReducer(List<Flower> state, dynamic action) {
  if (action is AddFlowerAction) {
    state.add(action.flower);
    return state;
  }

  if (action is AddFlowersAction) {
    return action.flowers;
  }

  if (action is UpdateFlowersAction) {
    return state.map((flower) {
      if (action.flower.key == flower.key) {
        return action.flower;
      }

      return flower;
    }).toList();
  }

  return state;
}

