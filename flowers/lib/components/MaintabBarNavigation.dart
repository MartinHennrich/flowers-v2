import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

import '../appState.dart';
import '../constants/colors.dart';
import './fabBottomAppBar.dart';
import './flowers-list-page/flowersListPage.dart';
import './today-page/todayPage.dart';
import '../utils/whatsNew.dart';
import './whats-new/whatsNewDialog.dart';
import '../actions/actions.dart';
import '../store.dart';
import '../utils/firstTimeUser.dart';
import '../ad.dart';
import '../flower.dart';

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
  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices: testDevices,
    keywords: adKeywords,
    childDirected: true,
  );
  BannerAd _bannerAd;

  BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: bannerId,
      size: AdSize.banner,
      targetingInfo: targetingInfo,
    );
  }

  @override
  void initState() {
    super.initState();
    FirebaseAdMob.instance.initialize(appId: appAdId);
    if (_bannerAd == null) {
      _bannerAd = createBannerAd()..load();
    } else {
      _bannerAd.dispose();
    }
  }

  @override
  void dispose() async {
    super.dispose();
    await _bannerAd?.dispose();
  }

  void _onInitialBuild(_ViewModel vm) {
    isFirstTimeUser()
      .then((bool isFirstTime) {
        AppStore.dispatch(
          isFirstTime
            ? IsFirstTimeUser.Yes
            : IsFirstTimeUser.No
        );

        // TODO: later update, add isFirstTime instead of false
        shouldSeeWhatsNew(false)
          .then((bool shouldSee) {
            if (shouldSee) {
              showDialog(
                context: context,
                builder: (_) => WhatsNewDialog()
              );
            }
          });
      });
  }

  void _onDidChange(_ViewModel vm) {
    if (_selectedIndex == 0) {
      if (vm.flowers.length > 0) {
        _bannerAd.isLoaded()
          .then((isLoaded) {
            if (!isLoaded) {
              _bannerAd..show(
                anchorOffset: 36,
                anchorType: AnchorType.top
              );
            }
          });
      }
    }
  }

  void _onItemTapped(int index) async {
    setState(() {
      if (index != 0) {
        print('disponse not 0');
        _bannerAd?.dispose();
      }

      if (index == 0 && _selectedIndex != 0) {
        print('load againt index 0');
        _bannerAd = createBannerAd()..load()
          .then((_) {
            _bannerAd.show(
              anchorOffset: 36,
              anchorType: AnchorType.top
            );
          });

      }

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
      onInitialBuild: _onInitialBuild,
      onDidChange: _onDidChange,
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
  final List<Flower> flowers;

  _ViewModel({
    this.isCreatingFlower,
    this.flowers,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      isCreatingFlower: store.state.isCreatingFlower,
      flowers: store.state.flowers,
    );
  }
}

