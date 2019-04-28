import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../actions/actions.dart';
import '../../appState.dart';
import '../../flower.dart';
import '../../presentation/custom_icons_icons.dart';
import '../../presentation/customScrollColor.dart';
import '../../reminders.dart';
import '../../store.dart';
import '../../utils/colors.dart';
import '../../utils/firebase-redux.dart';
import '../../utils/firebase.dart';
import '../../utils/labelsHelper.dart';
import '../../utils/notifications.dart';
import '../../utils/soilMoisture.dart';
import '../../utils/waterAmount.dart';
import '../add-labels/addLabels.dart';
import '../flowerCard.dart';
import './daysLeft.dart';
import './deleteDialog.dart';
import './edit.dart';
import './labels-list/labelsList.dart';
import './reminderInfoPanelCarousel.dart';
import './remindersList.dart';
import './timeGraph.dart';

class FlowerDetails extends StatefulWidget {
  final Flower flower;

  FlowerDetails({
    this.flower
  });

  @override
    State<StatefulWidget> createState() {
      return FlowerDetailsState();
    }

}

class FlowerDetailsState extends State<FlowerDetails> {
  bool isLoading = true;
  Color colorOfTime = Colors.black;
  Reminder closestReminder;
  bool isAnyRemindersActive = true;

  @override
  void initState() {
    super.initState();
    _initialState(widget.flower);
    _fetchFlowerData();
  }

  _initialState(Flower flower) {
    setState(() {
      colorOfTime = getColorForFlower(flower);
      closestReminder = flower.reminders.getClosestDate(DateTime.now());

      if (closestReminder == null) {
        isAnyRemindersActive = false;
      } else {
        isAnyRemindersActive = true;
      }
    });
  }

  @override
  void didUpdateWidget(FlowerDetails oldWidget) {
    super.didUpdateWidget(oldWidget);
    closestReminder = widget.flower.reminders.getClosestDate(DateTime.now());
    isAnyRemindersActive = closestReminder != null;
  }

  void _fetchFlowerData() async {
    if (widget.flower.waterTimes.length == 0) {
      try {
        DataSnapshot waterTimesSnapshot = await database.getFlowerWaterTimes(
          widget.flower.key
        );

        List<WaterTime> waterTimes = snapshotToWaterTime(waterTimesSnapshot);

        widget.flower.setWaterTimes(waterTimes);
        AppStore.dispatch(UpdateFlowerAction(widget.flower));
        setState((){
          isLoading = false;
        });
      } catch (e) {
        setState((){
          isLoading = false;
        });
      }
    } else {
      setState((){
        isLoading = false;
      });
    }
  }

  List<TimeSeriesValue> _sortOnTime(List<TimeSeriesValue> list) {
    list.sort((TimeSeriesValue a, TimeSeriesValue b) {
     return a.time.compareTo(b.time);
    });

    return list;
  }

  List<charts.Series<TimeSeriesValue, DateTime>> _getTimeSeriesSoil(Flower flower) {
    var data = _sortOnTime(flower.waterTimes.map((WaterTime waterTime) {
      return TimeSeriesValue(
        waterTime.wateredTime,
        soilMoistureToInt(waterTime.soilMoisture));
    }).toList().reversed.toList().take(50).toList().reversed.toList());

    return [charts.Series<TimeSeriesValue, DateTime>(
      id: 'soil',
      colorFn: (_, __) => charts.Color(
        r: colorOfTime.red, g: colorOfTime.green, b: colorOfTime.blue, a: colorOfTime.alpha),
      domainFn: (TimeSeriesValue data, _) => data.time,
      strokeWidthPxFn: (TimeSeriesValue data, _) => 3,
      measureFn: (TimeSeriesValue data, _) => data.value,
      data: data
    )];
  }

  List<charts.Series<TimeSeriesValue, DateTime>> _getTimeSeriesWaterAmount(Flower flower) {
    var data = _sortOnTime(flower.waterTimes.map((WaterTime waterTime) {
      return TimeSeriesValue(
        waterTime.wateredTime,
        waterAmountToInt(waterTime.waterAmount));
    }).toList().reversed.toList().take(50).toList().reversed.toList());

    return [charts.Series<TimeSeriesValue, DateTime>(
      id: 'waterAmount',
      colorFn: (_, __) => charts.Color(
        r: colorOfTime.red, g: colorOfTime.green, b: colorOfTime.blue, a: colorOfTime.alpha),
      domainFn: (TimeSeriesValue data, _) => data.time,
      strokeWidthPxFn: (TimeSeriesValue data, _) => 3,
      measureFn: (TimeSeriesValue data, _) => data.value,
      data: data
    )];
  }

  Widget _getGraphContainer(String title, Widget widget, double bootomPadding) {
    return Padding(
      padding: EdgeInsets.fromLTRB(32, 32, 16, bootomPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black38,
              fontSize: 12
            )
          ),
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: SizedBox(
              height: 200.0,
              child: widget
            )
          )
        ]
      )
    );
  }

  Widget _getSoilGraph(Flower flower) {
    return _getGraphContainer(
      'SOIL MOISTURE',
      TimeSeriesGraph(
        _getTimeSeriesSoil(flower),
        type: TimeGraphType.SoilM
      ),
      32
    );
  }

  Widget _getWaterAmountGraph(Flower flower) {
    return _getGraphContainer(
      'WATER AMOUNT',
      TimeSeriesGraph(
        _getTimeSeriesWaterAmount(flower),
        type: TimeGraphType.WaterAmount
      ),
      64
    );
  }

  Widget getGraphs(Flower flower) {
    if (isLoading) {
      return Container(
        height: 200,
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(colorOfTime),
          )
        )
      );
    }

    if (flower.waterTimes.length < 2) {
      return Center(child: Container(
        height: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              CustomIcons.emo_coffee,
              color: colorOfTime,
              size: 70,
            ),
            Padding(
              padding: EdgeInsets.only(top: 24),
              child:Text(
                'no graphs to show yet',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black38
                )
              )
            )
          ],
        )
      ));
    }

    return Column(
      children: <Widget>[
        _getSoilGraph(flower),
        _getWaterAmountGraph(flower)
      ],
    );
  }

  void _select(_MenuChoice menuChoice) {
    if (menuChoice.type == 'delete') {
      openDeleteDialog();
    } else if (menuChoice.type == 'edit') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditFlower(flower: widget.flower),
        ),
      );
    }
  }

  void openDeleteDialog() {
    showDialog(
      context: context,
      builder: (_) => DeleteDialog(
        name: widget.flower.name,
        onRemove: (context) {
          try {
            database.deleteFlower(widget.flower.key);
          } catch (e) {
            Navigator.of(context).pop();
          }
          widget.flower.reminders.getRemindersAsList()
            .forEach((reminder) {
              cancelOldNotifications(reminder.key);
            });
          Navigator.pop(context);
          AppStore.dispatch(DeleteFlowerAction(widget.flower));
          Navigator.of(context).pop();
        },
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector(
      onDidChange: (_ViewModel vm) {
        Flower flower = vm.flowers.firstWhere((flower) {
          return flower.key == widget.flower.key;
        });

        _initialState(flower != null ? flower : widget.flower);
      },
      converter: _ViewModel.fromStore,
      builder: (context, _ViewModel vm) {
        Flower flower = vm.flowers.firstWhere((flower) {
          return flower.key == widget.flower.key;
        });
        if (flower == null) {
          flower = widget.flower;
        }

        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Text(flower.name),
            actions: [
              PopupMenuButton<_MenuChoice>(
                onSelected: _select,
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem<_MenuChoice>(
                      value: _menuChoices[0],
                      child: Text(_menuChoices[0].title),
                    ),
                    PopupMenuItem<_MenuChoice>(
                      value: _menuChoices[1],
                      child: Text(_menuChoices[1].title),
                    )
                  ];
                },
              ),
            ]
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddLabels(
                    activeLabels: flower.labels,
                    allAvailable: getAllUniqLabelsForFlower(flower.labels),
                    flower: flower
                  ),
                ),
              );
            },
            backgroundColor: colorOfTime,
            child: Icon(Icons.label, color: Colors.white)
          ),
          backgroundColor: Colors.white,
          body: CustomScrollColor(child: ListView(
            children: [
              Container(
                color: Colors.white,
                padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FlowerCard(
                      flower: flower,
                      withHero: true,
                    ),

                    closestReminder != null
                      ? Expanded(child: DaysLeft(
                          reminder: closestReminder,
                          color: colorOfTime
                        ))
                      : Expanded(child: Container())
                  ],
                )
              ),
              LabelsList(labels: flower.labels, hasTitle: true),
              ReminderInfoPanelCarousel(reminders: flower.reminders.getRemindersAsList(sortActive: true)),
              RemindersList(flower: flower, reminders: flower.reminders,),
              getGraphs(flower)
            ]
          ))
        );
      }
    );
  }
}

class _MenuChoice {
  final String title;
  final String type;

  const _MenuChoice({this.title, this.type});
}

const List<_MenuChoice> _menuChoices = [
  _MenuChoice(title: 'Edit', type: 'edit'),
  _MenuChoice(title: 'Delete', type: 'delete'),
];


class _ViewModel {
  final List<Flower> flowers;

  _ViewModel({
    this.flowers,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      flowers: store.state.flowers
    );
  }
}
