import 'package:redux/redux.dart';

import './reducers/appReducer.dart';
import './appState.dart';
import './flower.dart';

final AppStore = Store<AppState>(
  appReducer,
  initialState: AppState(
    isFetchingData: true,
    flowers: []
  ),
);
