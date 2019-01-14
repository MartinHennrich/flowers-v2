import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import './fabBottomAppBar.dart';
import '../constants/colors.dart';
import './today-page/todayPage.dart';
import './flowers-list-page/flowersListPage.dart';
import '../appState.dart';

class MainPagesTabBar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainPagesTabBarState();
  }
}

class MainPagesTabBarState extends State<MainPagesTabBar>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  final _widgetOptions = [TodayPage(), FlowersListPage()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getFloatingActionButton(bool isLoading) {
    return FloatingActionButton(
      backgroundColor: GreenMain,
      onPressed: isLoading ? null : () {
        Navigator.pushNamed(context, '/create-flower');
      },
      child: isLoading
        ? CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          )
        : Icon(
            Icons.add,
            color: Colors.white,
          ),
    );
  }

  Widget _getBottomNavigationBar() {
    return FABBottomAppBar(
      centerItemText: 'Add plant',
      color: Colors.grey,
      selectedColor: BlueMain,
      onTabSelected: _onItemTapped,
      items: [
        FABBottomAppBarItem(iconData: Icons.local_florist, text: 'Today'),
        FABBottomAppBarItem(iconData: Icons.list, text: 'Garden')
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector(
      converter: _ViewModel.fromStore,
      builder: (context, _ViewModel vm) {
        return Scaffold(
          body: Center(
            child: SafeArea(child: _widgetOptions.elementAt(_selectedIndex)),
          ),
          bottomNavigationBar: _getBottomNavigationBar(),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          floatingActionButton: _getFloatingActionButton(vm.isCreatingFlower),
        );
    });
  }
}


class _ViewModel {
  final bool isCreatingFlower;

  _ViewModel({
    this.isCreatingFlower
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      isCreatingFlower: store.state.isCreatingFlower,
    );
  }
}

