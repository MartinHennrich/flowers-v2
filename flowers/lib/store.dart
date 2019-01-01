import 'package:redux/redux.dart';

import './reducers/appReducer.dart';
import './appState.dart';
import './flower.dart';

final AppStore = Store<AppState>(
  appReducer,
  initialState: AppState(
    flowers: [
      Flower(name: 'me 1', lastTimeWatered: DateTime.now()),
      Flower(name: 'me 2', lastTimeWatered: DateTime.now())
    ]
  ),
);
