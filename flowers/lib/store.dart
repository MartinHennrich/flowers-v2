import 'package:redux/redux.dart';

import './appState.dart';
import './reducers/appReducer.dart';

final AppStore = Store<AppState>(
  appReducer,
  initialState: AppState(
    isFetchingData: true,
    flowers: [],
    isCreatingFlower: false
  ),
);
