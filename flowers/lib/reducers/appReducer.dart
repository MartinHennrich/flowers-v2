import '../appState.dart';
import './flowersReducer.dart';

AppState appReducer(AppState state, dynamic action) {
  return AppState(
    flowers: flowersReducer(state.flowers, action)
  );
}
