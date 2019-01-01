import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import './store.dart';
import './appState.dart';
import './components/MaintabBarNavigation.dart';

void main() {
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

