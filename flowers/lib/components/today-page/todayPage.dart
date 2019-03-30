import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../flower.dart';
import '../../reminders.dart';
import '../../appState.dart';
import '../../constants/colors.dart';
import '../../utils/flowerHelpers.dart';
import '../flowersList.dart';
import './noFlowersToWater.dart';
import '../page-title.dart';
import './water-dialog/waterDialog.dart';
import './rotate-dialog/rotateDialog.dart';
import './fertilize-dialog/fertilizeDialog.dart';
import '../../ad.dart';

class TodayPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FlowerList(),
    );
  }
}

class FlowerList extends StatefulWidget {
  @override
  _FlowerListState createState() {
    return _FlowerListState();
  }
}

class _FlowerListState extends State<FlowerList> {

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
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  List<Widget> _getLoadingScreen() {
    return [
      PageTitle(title: 'Today'),
      Container(
        height: 300,
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(BlueMain),
          )
        )
      )
    ];
  }

  void openWaterDialog(BuildContext context, Flower flower) {
    showDialog(
      context: context,
      builder: (_) => WaterDialog(flower: flower)
    );
  }

  void openRotateDialog(BuildContext context, Flower flower) {
    showDialog(
      context: context,
      builder: (_) => RotateDialog(flower: flower)
    );
  }

  void openFertilizeDialog(BuildContext context, Flower flower) {
    showDialog(
      context: context,
      builder: (_) => FertilizeDialog(flower: flower)
    );
  }

  void _selectDialog(BuildContext context, Reminder reminder, Flower flower) {
    switch (reminder.type) {
      case ReminderType.Water:
        openWaterDialog(context, flower);
        break;
      case ReminderType.Fertilize:
        openFertilizeDialog(context, flower);
        break;
      case ReminderType.Rotate:
        openRotateDialog(context, flower);
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector(
      converter: _ViewModel.fromStore,
      builder: (context, _ViewModel vm) {
        if (vm.flowers.length > 0) {
          _bannerAd..show(
            anchorOffset: 36,
            anchorType: AnchorType.top
          );
        }
        List<Flower> flowersActiveWithReminders = getFlowersThatNeedAction(vm.flowers);
        var flowersToWaterWidget = FlowersList(
          flowers: flowersActiveWithReminders,
          withReminderBar: true,
          onPress: (Flower flower) {
            Reminder closestReminder = flower.reminders.getClosestDate(DateTime.now());
            _selectDialog(context, closestReminder, flower);

          },
        );

        List<Flower> completedFlowers = getFlowersThatHasBeenCompleted(vm.flowers);
        var flowersBeenWateredWidget = FlowersList(
          flowers: completedFlowers,
          disabled: true,

        );

        List<Widget> children = [
          PageTitle(title: 'Today'),
          flowersActiveWithReminders.length <= 0
            ? NoFlowersToWater(
              hasNoFlowers: vm.flowers.length == 0,
              hasCompleted: completedFlowers.length > 0
            )
            : Container(),
        ]
        ..add(
          flowersToWaterWidget
        )
        ..add(
          completedFlowers.length > 0
            ? PageTitle(
                title: 'Completed',
                fontSize: 40,
                padding: EdgeInsets.fromLTRB(0, 40, 0, 16)
              )
            : Container()
        )
        ..add(flowersBeenWateredWidget);

        return ListView(
          padding: EdgeInsets.all(20.0),
          children: vm.isFetchingData == true ? _getLoadingScreen() : children
        );
    });
  }
}

class _ViewModel {
  final List<Flower> flowers;
  final bool isFetchingData;

  _ViewModel({
    this.flowers,
    this.isFetchingData
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      flowers: store.state.flowers,
      isFetchingData: store.state.isFetchingData
    );
  }
}
