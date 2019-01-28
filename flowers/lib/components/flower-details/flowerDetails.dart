import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import '../../presentation/custom_icons_icons.dart';
import '../../flower.dart';
import '../../utils/soilMoisture.dart';
import '../../utils/waterAmount.dart';
import '../flowerCard.dart';
import '../../utils/colors.dart';
import '../../utils/dateHelpers.dart';
import '../../utils/firebase.dart';
import '../../utils/firebase-redux.dart';
import '../../actions/actions.dart';
import '../../store.dart';
import './timeGraph.dart';
import './deleteDialog.dart';

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

  @override
  void initState() {
    super.initState();

    setState(() {
      colorOfTime = getColorBasedOnTime2(
        widget.flower.reminders.water.nextTime,
        widget.flower.reminders.water.lastTime
      );
    });
    _fetchFlowerData();

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

  Widget _getDaysLeft() {
    DateTime today = preSetTimeFrame(DateTime.now());
    DateTime nextWatertime = preSetTimeFrame(widget.flower.reminders.water.nextTime);
    Duration diff = nextWatertime.difference(today);
    int daysLeft = 0;

    if (diff.inDays <= 0) {
      if (diff.inHours >= 1) {
        daysLeft = 1;
      } else {
        daysLeft = 0;
      }
    } else {
      daysLeft = diff.inDays;
    }


    return Container(
      height: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('$daysLeft', style: TextStyle(
            fontSize: 80,
            color: colorOfTime,
          )),
          Container(
            child: Text('${daysLeft == 1 ? 'day' : 'days'}\nremaining',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black38
              )
            )
          ),
        ],
      )
    );
  }

  String _getDayToWaterName() {
    DateTime today = preSetTimeFrame(DateTime.now());
    DateTime tomorrow = today.add(Duration(days: 1));
    DateTime nextTime = preSetTimeFrame(widget.flower.reminders.water.nextTime);

    if (tomorrow.day == nextTime.day && tomorrow.month == nextTime.month) {
      return 'tomorrow';
    }

    if (nextTime.day < today.day && today.month == nextTime.month) {
      return 'today!!';
    }

    if (today.day == nextTime.day && today.month == today.month) {
      return 'today';
    }

    return '${widget.flower.reminders.water.nextTime.month} / ${widget.flower.reminders.water.nextTime.day}';
  }

  String _getLastWaterTimeName() {
    DateTime today = preSetTimeFrame(DateTime.now());
    DateTime lastWateredTime = preSetTimeFrame(widget.flower.reminders.water.lastTime);
    DateTime yesterday = today.subtract(Duration(days: 1));

    if (today.day == lastWateredTime.day && today.month == lastWateredTime.month) {
      return 'today';
    }

    if (yesterday.day == lastWateredTime.day && yesterday.month == today.month) {
      return 'yesterday';
    }

    return '${lastWateredTime.month} / ${lastWateredTime.day}';
  }

  Widget _nextWaterTime() {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 32, 16, 6),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(right: 16),
            padding: EdgeInsets.only(left: 16),
            width: 144,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('LAST WATERED',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black38,
                    fontSize: 12
                  )),
                Padding(
                  padding: EdgeInsets.only(top: 6),
                  child: Text(
                    _getLastWaterTimeName(),
                    style: TextStyle(
                      fontSize: 28
                    )
                  )
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('WATER ON',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black38,
                    fontSize: 12
                  )),
                Padding(
                  padding: EdgeInsets.only(top: 6),
                  child: Text(
                    _getDayToWaterName(),
                    style: TextStyle(
                      fontSize: 28
                    )
                  )
                ),
              ],
            ),
          )
        ]
      )
    );
  }

  List<TimeSeriesValue> _sortOnTime(List<TimeSeriesValue> list) {
    list.sort((TimeSeriesValue a, TimeSeriesValue b) {
     return a.time.compareTo(b.time);
    });

    return list;
  }

  List<charts.Series<TimeSeriesValue, DateTime>> _getTimeSeriesSoil() {
    var data = _sortOnTime(widget.flower.waterTimes.map((WaterTime waterTime) {
      print(waterTime.wateredTime);
      return TimeSeriesValue(
        waterTime.wateredTime,
        soilMoistureToInt(waterTime.soilMoisture));
    }).toList().reversed.toList().take(50).toList().reversed.toList());

    return [charts.Series<TimeSeriesValue, DateTime>(
      id: 'soil',
      colorFn: (_, __) => charts.Color(
        r: colorOfTime.red, g: colorOfTime.green, b: colorOfTime.blue, a: colorOfTime.alpha),
      domainFn: (TimeSeriesValue data, _) => data.time,
      strokeWidthPxFn: (TimeSeriesValue data, _) => 6,
      measureFn: (TimeSeriesValue data, _) => data.value,
      data: data
    )];
  }

  List<charts.Series<TimeSeriesValue, DateTime>> _getTimeSeriesWaterAmount() {
    var data = _sortOnTime(widget.flower.waterTimes.map((WaterTime waterTime) {
      return TimeSeriesValue(
        waterTime.wateredTime,
        waterAmountToInt(waterTime.waterAmount));
    }).toList().reversed.toList().take(50).toList().reversed.toList());

    return [charts.Series<TimeSeriesValue, DateTime>(
      id: 'waterAmount',
      colorFn: (_, __) => charts.Color(
        r: colorOfTime.red, g: colorOfTime.green, b: colorOfTime.blue, a: colorOfTime.alpha),
      domainFn: (TimeSeriesValue data, _) => data.time,
      strokeWidthPxFn: (TimeSeriesValue data, _) => 6,
      measureFn: (TimeSeriesValue data, _) => data.value,
      data: data
    )];
  }

  Widget _getGraphContainer(String title, Widget widget) {
    return Padding(
      padding: EdgeInsets.fromLTRB(32, 32, 16, 32),
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

  Widget _getSoilGraph() {
    return _getGraphContainer(
      'SOIL MOISTURE',
      TimeSeriesGraph(
        _getTimeSeriesSoil(),
        type: TimeGraphType.SoilM
      ),
    );
  }

  Widget _getWaterAmountGraph() {
    return _getGraphContainer(
      'WATER AMOUNT',
      TimeSeriesGraph(
        _getTimeSeriesWaterAmount(),
        type: TimeGraphType.WaterAmount
      ),
    );
  }

  Widget getGraphs() {
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

    if (widget.flower.waterTimes.length < 2) {
      return Center(child: Container(
        height: 200,
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
        _getSoilGraph(),
        _getWaterAmountGraph()
      ],
    );
  }

  void _select(Choice choice) {
    if (choice.type == 'delete') {
      openDialog();
    }
  }

  void openDialog() {
    showDialog(
      context: context,
      builder: (_) => DeleteDialog(flower: widget.flower)
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(widget.flower.name),
        actions: [
          PopupMenuButton<Choice>(
            onSelected: _select,
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<Choice>(
                  value: choices,
                  child: Text(choices.title),
                )
              ];
            },
          ),
        ]
      ),

      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                FlowerCard(
                  flower: widget.flower,
                  withHero: true,
                ),

                Expanded(child:_getDaysLeft())
              ],
            )
          ),
          _nextWaterTime(),
          getGraphs()
        ]
      )
    );
  }
}

class Choice {
  final String title;
  final IconData icon;
  final String type;

  const Choice({this.title, this.icon, this.type});
}

const Choice choices = Choice(title: 'Delete', icon: Icons.directions_car, type: 'delete');
