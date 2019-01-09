import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../flower.dart';
import '../../appState.dart';
import '../page-title.dart';
import '../../constants/colors.dart';
import '../flowersList.dart';
import './emptyList.dart';

class FlowersListPage extends StatelessWidget {

  List<Widget> _getLoadingScreen() {
    return [
      PageTitle(title: 'Flowers'),
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

  List<Flower> _sortFlowersAlphabetically(List<Flower> flowers) {
    flowers.sort((a, b) {
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });
    return flowers;
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector(
      converter: _ViewModel.fromStore,
      builder: (context, _ViewModel vm) {
        List<Flower> sorted = _sortFlowersAlphabetically(vm.flowers);

        List<Widget> children = [
          PageTitle(title: 'Flowers'),
          FlowersList(
            flowers: sorted,
            onPress: (Flower flower) {

            },
            overrideColor: GreenGradient
          ),
          vm.flowers.length == 0
            ? EmptyList()
            : Container()
        ];

        return ListView(
          padding: EdgeInsets.all(20.0),
          children: vm.isFetchingData == true ? _getLoadingScreen() : children
        );
      }
    );
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
