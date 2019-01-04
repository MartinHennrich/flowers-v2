import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../flower.dart';
import '../../appState.dart';
import '../../constants/colors.dart';
import '../../utils/flowerHelpers.dart';
import '../../presentation/custom_icons_icons.dart';
import './flowersList.dart';

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

  // TODO: split to seperate StatelessWidget
  Widget _getTitle() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 24, 0, 40),
      child: Text('Today',
        style: TextStyle(
          fontSize: 60,
          fontWeight: FontWeight.bold,
          color: Color.fromRGBO(0, 0, 0, 0.3)
        ),
      ),
    );
  }
  // TODO: split to seperate StatelessWidget
  Widget _getWateredTodayTitle() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 24, 0, 40),
      child: Text('Watered',
        style: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.bold,
          color: Color.fromRGBO(0, 0, 0, 0.3)
        ),
      ),
    );
  }
  // TODO: split to seperate StatelessWidget
  Widget _getNoFlowersToWater() {
    return Container(
      /* height: 200, */
      padding: EdgeInsets.fromLTRB(0, 68, 0, 68),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            CustomIcons.emo_grin,
            color: SecondMainColor,
            size: 70,
          ),
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text('no flowers to water',
              style: TextStyle(
                color: Color.fromRGBO(0, 0, 0, 0.3)
              ),
            )
          ),
        ],
      )
    );
  }
  // TODO: split to seperate StatelessWidget
  List<Widget> _getLoadingScreen() {
    return [
      _getTitle(),
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

        // TODO: have a blur ish or gray color overlay instaed of pink
        // or change opacity of card
        List<Flower> flowersBeenWatered = getFlowersThatHasBeenWatered(vm.flowers);
        var flowersBeenWateredWidget = FlowersList(
          flowers: flowersBeenWatered,
          disabled: true,
        );

        List<Widget> children = [
          _getTitle(),
          flowersToWater.length <= 0 ? _getNoFlowersToWater() : Container(),
        ]
        ..add(
          flowersToWaterWidget
        )
        ..add(
          flowersBeenWatered.length > 0 ? _getWateredTodayTitle() : Container()
        )
        ..add(flowersBeenWateredWidget);

        return ListView(
          shrinkWrap: true,
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
