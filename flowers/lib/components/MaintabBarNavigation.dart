import 'package:flutter/material.dart';
import './fabBottomAppBar.dart';
import '../constants/colors.dart';
import './today-page/todayPage.dart';

class MainPagesTabBar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainPagesTabBarState();
  }
}

class MainPagesTabBarState extends State<MainPagesTabBar>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  final _widgetOptions = [TodayPage(), HomePage2()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getFloatingActionButton() {
    return FloatingActionButton(
      backgroundColor: MainSecondColor,
      onPressed: () {},
      child: Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }

  Widget _getBittomNavigationBar() {
    return FABBottomAppBar(
      centerItemText: 'Add flower',
      color: Colors.grey,
      selectedColor: MainColor,
      onTabSelected: _onItemTapped,
      items: [
        FABBottomAppBarItem(iconData: Icons.local_florist, text: 'Today'),
        FABBottomAppBarItem(iconData: Icons.list, text: 'Flowers')
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SafeArea(child: _widgetOptions.elementAt(_selectedIndex)),
      ),
      bottomNavigationBar: _getBittomNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _getFloatingActionButton(),
    );
  }
}


class HomePage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[Text('HEJ 2')],
      ),
    );
  }
}
