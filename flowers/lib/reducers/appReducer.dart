import '../appState.dart';
import './creatingFlowerReducer.dart';
import './fetchingDataReducer.dart';
import './flowersReducer.dart';

AppState appReducer(AppState state, dynamic action) {
  return AppState(
    flowers: flowersReducer(state.flowers, action),
    isFetchingData: isFetchingDataReducer(state.isFetchingData, action),
    isCreatingFlower: isCreatingFlowerReducer(state.isCreatingFlower, action)
  );
}
