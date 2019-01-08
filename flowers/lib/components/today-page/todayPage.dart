import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../flower.dart';
import '../../appState.dart';
import '../../constants/colors.dart';
import '../../utils/flowerHelpers.dart';
import './flowersList.dart';
import './noFlowersToWater.dart';
import './title.dart';
import '../scrollBehavior.dart';

class TodayPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FlowerList(),
    );
  }
}

class FlowerList extends StatelessWidget {

  List<Widget> _getLoadingScreen() {
    return [
      TodayPageTitle(title: 'Today'),
      Container(
        height: 300,
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(SecondMainColor),
          )
        )
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector(
      converter: _ViewModel.fromStore,
      builder: (context, _ViewModel vm) {
        List<Flower> flowersToWater = getFlowersThatNeedWater(vm.flowers);
        var flowersToWaterWidget = FlowersList(
          flowers: flowersToWater
        );

        List<Flower> flowersBeenWatered = getFlowersThatHasBeenWatered(vm.flowers);
        var flowersBeenWateredWidget = FlowersList(
          flowers: flowersBeenWatered,
          disabled: true,
        );

        List<Widget> children = [
          TodayPageTitle(title: 'Today'),
          flowersToWater.length <= 0
            ? NoFlowersToWater(
              hasNoFlowers: vm.flowers.length == 0,
              hasCompleted: flowersBeenWatered.length > 0
            )
            : Container(),
        ]
        ..add(
          flowersToWaterWidget
        )
        ..add(
          flowersBeenWatered.length > 0
            ? TodayPageTitle(title: 'Watered', fontSize: 40,)
            : Container()
        )
        ..add(flowersBeenWateredWidget);

        return ScrollConfiguration(
          behavior: MyBehavior(),
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.all(20.0),
            children: vm.isFetchingData == true ? _getLoadingScreen() : children
          )
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
