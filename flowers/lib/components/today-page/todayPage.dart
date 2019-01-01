import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../flower.dart';
import '../../appState.dart';
import '../../constants/colors.dart';

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

  List<Widget> _getFlowersListWidgets(List<Flower> flowers) {
    return flowers.map((flower) {
      print(flower.name);
      return GestureDetector(
        onTap: () {
          print('watering');
        },
        child: Container(
          margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
          decoration: BoxDecoration(
            color: SecondMainColor,
            image: DecorationImage(
              image: NetworkImage('https://i.imgur.com/svViHqm.jpg'),
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

  @override
  Widget build(BuildContext context) {
    return StoreConnector(
      converter: _ViewModel.fromStore,
      builder: (context, _ViewModel vm) {
        List<Widget> children = [
          Container(
            height: 20,
            alignment: Alignment(-1.0, 0.0),
            padding: EdgeInsets.fromLTRB(0, 0, 0, 24),
            child: Text('Today',
              style: TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(0, 0, 0, 0.3)
              ),
            ),
          ),
          Container(
            height: 20,
          )
        ];
        children.addAll(_getFlowersListWidgets(vm.flowers));

        return GridView.count(
          primary: false,
          crossAxisSpacing: 10.0,
          crossAxisCount: 2,
          padding: EdgeInsets.all(20.0),
          children: children
        );
    });
  }
}

class _ViewModel {
  final List<Flower> flowers;

  _ViewModel({
    this.flowers
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      flowers: store.state.flowers
    );
  }
}
