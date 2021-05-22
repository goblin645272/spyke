import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:spyke/entities/StockData.dart';
import 'package:spyke/entities/network.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class SimpleTimeSeriesChart extends StatefulWidget {
  String period;
  String ticker;
  SimpleTimeSeriesChart({Key key, @required this.ticker, @required this.period})
      : super(key: key);

  @override
  _SimpleTimeSeriesChartState createState() => _SimpleTimeSeriesChartState();
}

class _SimpleTimeSeriesChartState extends State<SimpleTimeSeriesChart> {
  List<GraphData> ndata = List<GraphData>();
  List<GraphData> ddata = [];
  TooltipBehavior _tool;
  bool _isLoading = true;
  void initState() {
    loaddata();
  }

  loaddata() async {
    fetchgraphdata(widget.ticker, widget.period).then((value) {
      ndata.addAll(value);
      ddata = createchart(ndata);
      if (mounted) {
        setState(() {
          _tool = TooltipBehavior(enable: true);
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var xformatter = formatMap[widget.period];

    return Container(
        child: (() {
      if (!_isLoading) {
        return SfCartesianChart(
          title: ChartTitle(
              text: 'Stock Graph of ${dataPerDay[widget.period]}',
              textStyle: TextStyle(color: Colors.white)),
          tooltipBehavior: _tool,
          series: <ChartSeries>[
            LineSeries<GraphData, DateTime>(
              dataSource: ddata,
              xValueMapper: (GraphData _data, _) => _data.timestamp,
              yValueMapper: (GraphData _data, _) => _data.close,
              color: Colors.green,
              enableTooltip: true,
            ),
          ],
          primaryXAxis: DateTimeAxis(
              labelStyle: TextStyle(color: Colors.white),
              majorGridLines: MajorGridLines(width: 0),
              dateFormat: xformatter,
              edgeLabelPlacement: EdgeLabelPlacement.shift),
          primaryYAxis: NumericAxis(
            labelStyle: TextStyle(color: Colors.white),
            majorGridLines: MajorGridLines(width: 0),
            numberFormat:
                NumberFormat.simpleCurrency(decimalDigits: 0, locale: 'hi'),
          ),
        );
      } else {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
    }()));
  }

  Map<String, String> dataPerDay = {
    "1d": 'Today/Yesterday',
    "7d": 'Last 7 days',
    "1m": 'Last 30 days',
    "6m": 'Last 6 months',
    "1y": 'Last 12 months',
  };

  Map<String, DateFormat> formatMap = {
    "1d": DateFormat("h꞉mm a"),
    "7d": DateFormat.MMMd(),
    "1m": DateFormat.MMMd(),
    "6m": DateFormat.MMMd(),
    "1y": DateFormat.MMMd(),
  };
}
