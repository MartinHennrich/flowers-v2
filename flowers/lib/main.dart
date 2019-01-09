import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import './components/create-flower/createFlower.dart';
import './store.dart';
import './actions/actions.dart';
import './appState.dart';
import './components/MaintabBarNavigation.dart';
import './utils/firebase.dart';
import './utils/firebase-redux.dart';

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
        debugShowCheckedModeBanner: false,
        title: 'Flowers',
        theme: ThemeData(
          primaryColor: Colors.white
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => MainPagesTabBar(),
          '/create-flower': (context) => CreateFlower()
        },
      ),
    );
  }
}

