import '../appState.dart';
import './flowersReducer.dart';
import './creatingFlowerReducer.dart';
import './fetchingDataReducer.dart';

AppState appReducer(AppState state, dynamic action) {
  return AppState(
    flowers: flowersReducer(state.flowers, action),
    isFetchingData: isFetchingDataReducer(state.isFetchingData, action),
    isCreatingFlower: isCreatingFlowerReducer(state.isCreatingFlower, action)
  );
}
