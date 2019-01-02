import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import './store.dart';
import './actions/actions.dart';
import './appState.dart';
import './components/MaintabBarNavigation.dart';
import './utils/firebase.dart';
import './utils/firebase-redux.dart';

Database database = Database();

void main() {
  database
    .getIntialData()
    .then((snapshot) {
      addSnapshotToRedux(snapshot);
      AppStore.dispatch(FetchingData.Completed);
    });
  runApp(App(store: AppStore));
}

class App extends StatelessWidget {
  final Store<AppState> store;

  App({this.store});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.white,
    ));

    return StoreProvider(
        store: store,
        child: MaterialApp(
          title: 'Flowers',
          theme: ThemeData(
            primarySwatch: Colors.grey),
          home: MainPagesTabBar(),
        ));
  }
}

