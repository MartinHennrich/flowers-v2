import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

import '../../appState.dart';
import '../../constants/colors.dart';
import '../../flower.dart';
import '../../presentation/customScrollColor.dart';
import '../../utils/loadInitialData.dart';
import '../flower-details/flowerDetails.dart';
import '../flowersList.dart';
import '../page-title.dart';
import './emptyList.dart';
import '../flower-details/labels-list/labelsList.dart';
import '../../utils/labelsHelper.dart';

class FlowersListPage extends StatefulWidget {

  @override
  FlowersListPageState createState() {
    return FlowersListPageState();
  }
}

class FlowersListPageState extends State<FlowersListPage> {
  List<Label> selectedLabels = [];

  List<Widget> _getLoadingScreen() {
    return [
      PageTitle(title: 'Garden'),
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

  void _onInitialFetchError(BuildContext context) {
    final snackBar = SnackBar(
      content: Text('Could not load :('),
      duration: Duration(seconds: 60),
      action: SnackBarAction(
        textColor: GreenMain,
        label: 'Try again',
        onPressed: () {
          loadInitialData();
        },
      ),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  List<Flower> _req(List<Flower> subFlowers, Label selectedLabel) {
    List<Flower> filterFlowers = [];

    subFlowers.forEach((flower) {
      var v = flower.labels.firstWhere(
        (label) => label.value == selectedLabel.value,
        orElse: () => null
      );

      if (v != null) {
        var hasFlower = filterFlowers.firstWhere(
          (fFlower) => fFlower.key == flower.key,
          orElse: () => null
        );

        if (hasFlower == null) {
          filterFlowers.add(flower);
        }
      }
    });

    return filterFlowers;
  }

  List<Flower> _filterOnSelectedLabels(List<Flower> flowers) {
    List<Flower> filterFlowers = flowers;

    selectedLabels.forEach((selectedLabel) {
      filterFlowers = _req(filterFlowers, selectedLabel);
    });

    return filterFlowers;
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector(
      onDidChange: (_ViewModel vm) {
        if (vm.isFetchingData == null) {
          _onInitialFetchError(context);
        }
      },
      converter: _ViewModel.fromStore,
      builder: (context, _ViewModel vm) {
        List<Label> allLabels = getAllUniqLabels();
        List<Flower> sorted = _sortFlowersAlphabetically(
          selectedLabels.length > 0
            ? _filterOnSelectedLabels(vm.flowers)
            : vm.flowers
        );

        if (allLabels.length == 0 && selectedLabels.length > 0) {
          setState(() {
            selectedLabels = [];
          });
        }

        List<Widget> children = [
          PageTitle(
            title: 'Garden',
            padding: EdgeInsets.fromLTRB(20, 44, 20, allLabels.length > 0 ? 10 : 40),
          ),
          allLabels.length > 0
            ? Padding(
              padding: EdgeInsets.only(bottom: 0),
              child: LabelsList(
                labels: getAllUniqLabels(),
                selected: selectedLabels,
                onLabelPress: (Label label) {
                  if (selectedLabels.firstWhere(
                    (selectedLabel) => selectedLabel.value == label.value,
                    orElse: () => null) == null) {
                      setState(() {
                        selectedLabels.add(label);
                      });
                  } else {
                    setState(() {
                      selectedLabels = selectedLabels.where(
                        (selectedLabel) => selectedLabel.value != label.value
                      ).toList();
                    });
                  }
                },
              ),
            )
            : Container(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: FlowersList(
              flowers: sorted,
              withHero: true,
              onPress: (Flower flower) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FlowerDetails(flower: flower),
                  ),
                );
              },
            ),
          ),
          vm.flowers.length == 0
            ? EmptyList()
            : Container()
        ];

        return Scaffold(
          backgroundColor: Colors.white,
          body: CustomScrollColor(child: ListView(
            padding: EdgeInsets.only(bottom: 20),
            children: vm.isFetchingData == true ? _getLoadingScreen() : children
          ),
        ));
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
