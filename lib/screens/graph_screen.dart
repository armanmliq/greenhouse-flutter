import 'dart:async';
import 'dart:developer';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:greenhouse/constant/constant.dart' as constant;
import 'package:intl/intl.dart';

List<SensorHistory> SensorHistoryList = [];
String? minVal;
String? maxVal;

class SensorHistory {
  SensorHistory(this.unix, this.ValueSensor);
  final DateTime unix;
  final double ValueSensor;
}

class Graph1 extends StatefulWidget {
  @override
  State<Graph1> createState() => _Graph1State();
}

class _Graph1State extends State<Graph1> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 6,
        child: Scaffold(
          backgroundColor: constant.backgroundColor,
          appBar: AppBar(
            backgroundColor: constant.backgroundColor,
            bottom: const TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: 1,
              indicatorColor: Colors.black,
              automaticIndicatorColorAdjustment: true,
              isScrollable: true,
              tabs: [
                Tab(
                  text: 'Ph\nair',
                ),
                Tab(
                  text: 'Ppm\nair',
                ),
                Tab(
                  text: 'Temp\nroom',
                ),
                Tab(
                  text: 'Humid\nroom',
                ),
                Tab(
                  text: 'Temp\nair',
                ),
                Tab(
                  text: 'peny\niraman',
                ),
              ],
            ),
            title: const Text('Grafik'),
          ),
          body: const TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              ChartBuilder(
                SensorType: 'ph',
              ),
              ChartBuilder(
                SensorType: 'ppm',
              ),
              ChartBuilder(
                SensorType: 'temp',
              ),
              ChartBuilder(
                SensorType: 'humidity',
              ),
              ChartBuilder(
                SensorType: 'waterTemp',
              ),
              ChartBuilder(
                SensorType: 'statusPompaPenyiraman',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChartBuilder extends StatefulWidget {
  final String SensorType;

  const ChartBuilder({
    Key? key,
    required this.SensorType,
  }) : super(key: key);

  @override
  State<ChartBuilder> createState() => _ChartBuilderState();
}

class _ChartBuilderState extends State<ChartBuilder> {
  Map dataFetch = {};
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await FirebaseGet();
    });
  }

  FirebaseGet() async {
    try {
      Map defaultData = {};
      await FirebaseDatabase.instance
          .ref()
          .child('users')
          .child(constant.uid)
          .child('grafik')
          .child(widget.SensorType)
          .get()
          .then((DataSnapshot snapshot) {
        setState(() {
          dataFetch = snapshot.value as Map;
        });
        constant.grafikData = snapshot.value as Map;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GraphWidget(
      dataFetch: dataFetch,
      SensorType: widget.SensorType,
    );
  }
}

class GraphWidget extends StatefulWidget {
  Map<dynamic, dynamic> dataFetch;
  String SensorType;
  GraphWidget({
    Key? key,
    required this.SensorType,
    required this.dataFetch,
  });

  @override
  State<GraphWidget> createState() => _GraphWidgetState();
}

double? findMax;
double? findLow;

class _GraphWidgetState extends State<GraphWidget> {
  double maxXAxis = 1000;
  double minXAxis = 0;
  double maxVal = 0;
  double minVal = 0;
  late ZoomPanBehavior zoomPanBehavior;
  @override
  void initState() {
    zoomPanBehavior = ZoomPanBehavior(
      enablePinching: true,
      enablePanning: true,
      zoomMode: ZoomMode.x,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SensorHistoryList = [];
    Map _dataFetch = {};
    switch (widget.SensorType) {
      case 'ph':
        maxXAxis = 13;
        break;
      case 'ppm':
        maxXAxis = 2000;
        break;
      case 'humidity':
        maxXAxis = 100;
        break;
      case 'temp':
        maxXAxis = 80;
        break;
      case 'waterTemp':
        maxXAxis = 80;
        break;
      case 'statusPompaPenyiraman':
        maxXAxis = 1;
        break;
      default:
    }

    widget.dataFetch.forEach((key, value) {
      try {
        _dataFetch[value['ts']] = value['value'].toString();
      } catch (e) {
        print(e);
      }
    });

    //SORT MAP KEYS (Base Timestamp)
    var sortedKeys = _dataFetch.keys.toList()..sort();
    var reverseKey = sortedKeys.reversed;

    var sortedMap = {
      for (var key in reverseKey) key: _dataFetch[key]!,
    };

    try {
      // log(sortedMap.toString());
      final now = DateTime.now().toLocal();
      log("[_GraphWidgetState]print now $now");
      log('[_GraphWidgetState]sortedMap ${sortedMap.toString()}');
      if (sortedMap.isNotEmpty) {
        sortedMap.forEach(
          (k, v) {
            DateTime localDate = DateTime.fromMillisecondsSinceEpoch(
              k * 1000,
            ).toLocal();

            //add to graph list
            try {
              //add only current day
              var dateGraph =
                  DateTime.fromMillisecondsSinceEpoch(k * 1000).toLocal();

              log("[_GraphWidgetState]print dateGraph $dateGraph");
              log("[_GraphWidgetState]print compare ");
              bool parsingOnlyLastDays = dateGraph.isAfter(
                now.subtract(
                  Duration(days: 1),
                ),
              );
              if (parsingOnlyLastDays) {
                double value = 0;
                try {
                  value = double.parse(v);
                  print(localDate);
                  if (maxVal < value) {
                    print('>>  ${value.runtimeType}');
                    maxVal = value;
                  }
                  //Find Low
                  if (minVal > value || minVal == 0) {
                    minVal = value;
                  }
                  SensorHistoryList.add(
                    SensorHistory(
                      localDate,
                      value,
                    ),
                  );
                } catch (e) {
                  print(e);
                }
                ;
              }
            } catch (er) {
              //ERROR CATCH
            }
          },
        );
      }
    } catch (e) {
      print(e);
    }

    if (SensorHistoryList.isEmpty) {
      SensorHistory(DateTime.now(), 0.0);
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: Container(
            height: constant.height! * 0.6,
            color: Colors.white,
            child: SfCartesianChart(
              zoomPanBehavior: zoomPanBehavior,
              legend: Legend(
                isVisible: true,
                // Legend will be placed at the left
              ),
              enableAxisAnimation: false,
              primaryXAxis: DateTimeAxis(
                intervalType: DateTimeIntervalType.auto,
                desiredIntervals: 10,
                enableAutoIntervalOnZooming: true,
                dateFormat: DateFormat.jms(),
                borderColor: Colors.red,
                labelStyle: const TextStyle(
                  color: Colors.white,
                ),
              ),
              primaryYAxis: NumericAxis(
                minimum: minXAxis,
                maximum: maxXAxis,
                majorTickLines: const MajorTickLines(size: 0),
                labelAlignment: LabelAlignment.end,
                labelStyle: const TextStyle(
                  color: Colors.white,
                ),
              ),
              tooltipBehavior: TooltipBehavior(
                enable: true,
              ),
              plotAreaBackgroundColor: Colors.white10,
              borderColor: Colors.white,
              title: ChartTitle(
                textStyle: const TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.normal,
                    color: Colors.white),
                text: 'Hari Ini',
              ),
              backgroundColor: constant.backgroundColor,
              series: <ChartSeries>[
                // Renders line chart

                AreaSeries<SensorHistory, DateTime>(
                  markerSettings: const MarkerSettings(
                    borderColor: Colors.white,
                    isVisible: true,
                    color: Colors.white,
                    width: 1,
                    height: 1,
                  ),
                  name: widget.SensorType,
                  enableTooltip: true,
                  xAxisName: 'time',
                  yAxisName: '${widget.SensorType} ',
                  borderColor: Colors.white,
                  borderWidth: 1,
                  color: constant.backgroundColor,
                  dataSource: SensorHistoryList,
                  xValueMapper: (SensorHistory history, _) => history.unix,
                  yValueMapper: (SensorHistory history, _) =>
                      history.ValueSensor,
                )
              ],
            ),
          ),
        ),
        TextHighLow(maxVal: maxVal.toString(), minVal: minVal.toString())
      ],
    );
  }
}

class TextHighLow extends StatelessWidget {
  final String minVal;
  final String maxVal;
  TextHighLow({required this.minVal, required this.maxVal});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextHighLowItem(TitleText: 'Max', Value: maxVal),
        TextHighLowItem(TitleText: 'Min', Value: minVal),
      ],
    );
  }
}

class TextHighLowItem extends StatelessWidget {
  String TitleText = '';
  String Value = '';

  TextHighLowItem({
    Key? key,
    required this.TitleText,
    required this.Value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Container(
        color: Colors.blue,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(
                    TitleText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                  Text(
                    Value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Map inverse(Map f) {
  Map inverse = {};
  f.values.toSet().forEach((y) {
    inverse[y] = f.keys.where((x) => f[x] == y).toSet();
  });
  return inverse;
}
