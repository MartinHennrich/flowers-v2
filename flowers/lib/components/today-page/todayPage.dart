import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../flower.dart';
import '../../appState.dart';
import '../../constants/colors.dart';
import '../../utils/flowerHelpers.dart';

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
  List<Widget> _getFlowersListWidgets(List<Flower> flowers) {
    return flowers.map((flower) {
      return GestureDetector(
        onTap: () {
          print('watering');
        },
        child: Container(
          width: 160,
          height: 190,
          margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
          decoration: BoxDecoration(
            color: SecondMainColor,
            image: DecorationImage(
              image: NetworkImage(flower.imageUrl),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                height: 50,
                alignment: Alignment(-1.0, 0.0),
                padding: EdgeInsets.only(left: 16),
                decoration: BoxDecoration(
                  color: SecondMainColor,
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(8.0)),
                ),
                child: Text(
                  flower.name,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  )
                )
              ),
            ],
          )
        )
      );
    }).toList();
  }
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
      height: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.sentiment_satisfied,
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

  List<Row> _buildFlowerRows(List<List<Widget>> pairedFlowers) {
    return pairedFlowers.map((flowerPair) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: flowerPair.cast<Widget>(),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector(
      converter: _ViewModel.fromStore,
      builder: (context, _ViewModel vm) {
        List<Widget> flowersToWater = _buildFlowerRows(
          pairFlowers(
            _getFlowersListWidgets(
              getFlowersThatNeedWater(vm.flowers)
            )
          )
        );

        // TODO: have a blur ish or gray color overlay instaed of pink
        // or change opacity of card
        List<Widget> flowersBeenWatered = _buildFlowerRows(
          pairFlowers(
            _getFlowersListWidgets(
              getFlowersThatHasBeenWatered(vm.flowers)
            )
          )
        );

        List<Widget> children = [
          _getTitle(),
          flowersToWater.length <= 0 ? _getNoFlowersToWater() : Container(),
        ]
        ..add(
          Container(
            height: 300,
            child: Column(
              children: flowersToWater,
            )
          )
        )
        ..add(
          flowersBeenWatered.length > 0 ? _getWateredTodayTitle() : Container()
        )
        ..addAll(flowersBeenWatered);

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
