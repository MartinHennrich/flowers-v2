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
    _bannerAd = createBannerAd()..load();
  }

  @override
  void dispose() async {
    super.dispose();
    await _bannerAd?.dispose();
  }

  void _onInitialBuild(_ViewModel vm) {
    isFirstTimeUser()
      .then((bool isFirstTime) {});

      if (!vm.isFirstTimeUser) {
        AppStore.dispatch(
          IsFirstTimeUser.No
        );
      }

      // TODO: later update, add isFirstTime instead of false
      shouldSeeWhatsNew(vm.isFirstTimeUser)
        .then((bool shouldSee) {
          if (shouldSee) {
            showDialog(
              context: context,
              builder: (_) => WhatsNewDialog()
            );
          }
        });
      _createAdForPage(vm);
  }

  void _createAdForPage(_ViewModel vm) {
    if (_selectedIndex == 0) {
      if (_bannerAd != null) {
        _bannerAd..show(
          anchorOffset: 36,
          anchorType: AnchorType.top
        );
      }
    }
  }

  void _onDidChange(_ViewModel vm) {
    _createAdForPage(vm);
  }

  void _onItemTapped(int index) async {
    setState(() {
      if (index != 0) {
        _bannerAd?.dispose()
          .then((_) {
            _bannerAd = null;
          })
          .catchError((_) {
            // swallow
          });
      }

      if (index == 0 && _selectedIndex != 0) {
        if (_bannerAd == null) {
          _bannerAd = createBannerAd()..load()
            .then((_) {
              _bannerAd.show(
                anchorOffset: 36,
                anchorType: AnchorType.top
              );
            });
        }
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
  final bool isFirstTimeUser;

  _ViewModel({
    this.isCreatingFlower,
    this.flowers,
    this.isFirstTimeUser,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      isCreatingFlower: store.state.isCreatingFlower,
      flowers: store.state.flowers,
      isFirstTimeUser: store.state.isFirstTimeUser,
    );
  }
}

