import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

enum TimeGraphType {
  WaterAmount,
  SoilM
}

class TimeSeriesGraph extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;
  final TimeGraphType type;

  TimeSeriesGraph(this.seriesList, {this.animate, this.type = TimeGraphType.WaterAmount});

  List<charts.TickSpec<int>> _tickWaterAmountSpec() {
    return <charts.TickSpec<int>>[
      charts.TickSpec(0, label: 'small'),
      charts.TickSpec(1, label: 'normal'),
      charts.TickSpec(2, label: 'lots'),
    ];
  }

  List<charts.TickSpec<int>> _tickSoilMSpec() {
    return <charts.TickSpec<int>>[
      charts.TickSpec(0, label: 'dry'),
      charts.TickSpec(25, label: 'little dry'),
      charts.TickSpec(50, label: 'just right'),
      charts.TickSpec(75, label: 'little wet'),
      charts.TickSpec(100, label: 'wet'),
    ];
  }

  List<charts.TickSpec<int>> _selectSpec() {
    if (type == TimeGraphType.SoilM) {
      return _tickSoilMSpec();
    }

    return _tickWaterAmountSpec();
  }

  @override
  Widget build(BuildContext context) {
    return charts.TimeSeriesChart(
      seriesList,
      animate: animate,
      defaultRenderer: charts.LineRendererConfig(
        includePoints: true,
      ),
      primaryMeasureAxis: charts.NumericAxisSpec(
        tickProviderSpec: charts.StaticNumericTickProviderSpec(_selectSpec()),
        renderSpec: charts.GridlineRendererSpec(
          lineStyle: charts.LineStyleSpec(
            dashPattern: [4, 4],
          )
        )
      )
    );
  }
}

class TimeSeriesValue {
  final DateTime time;
  final int value;

  TimeSeriesValue(this.time, this.value);
}
