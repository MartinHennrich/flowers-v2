import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../flower.dart';
import '../../appState.dart';
import '../../constants/colors.dart';
import '../../utils/flowerHelpers.dart';
import '../flowersList.dart';
import './noFlowersToWater.dart';
import '../page-title.dart';
import './water-dialog/waterDialog.dart';

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

  void openDialog(BuildContext context, Flower flower) {
    showDialog(
      context: context,
      builder: (_) => WaterDialog(flower: flower)
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector(
      converter: _ViewModel.fromStore,
      builder: (context, _ViewModel vm) {
        List<Flower> flowersToWater = getFlowersThatNeedAction(vm.flowers);
        var flowersToWaterWidget = FlowersList(
          flowers: flowersToWater,
          onPress: (Flower flower) {
            openDialog(context, flower);
          },
        );

        List<Flower> flowersBeenWatered = getFlowersThatHasBeenCompleted(vm.flowers);
        var flowersBeenWateredWidget = FlowersList(
          flowers: flowersBeenWatered,
          disabled: true,

        );

        List<Widget> children = [
          PageTitle(title: 'Today'),
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
