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

Future<DataSnapshot> PhRoot = FirebaseDatabase.instance
    .ref()
    .child('users')
    .child(constant.uid)
    .child('grafik')
    .child('PH')
    .get();

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
        animationDuration: const Duration(milliseconds: 100),
        length: 4,
        child: Scaffold(
          backgroundColor: constant.AppBarColor,
          appBar: AppBar(
            backgroundColor: constant.backgroundColor,
            bottom: const TabBar(
              indicatorSize: TabBarIndicatorSize.label,
              indicatorWeight: 1,
              indicatorColor: Colors.black,
              automaticIndicatorColorAdjustment: true,
              tabs: [
                Tab(
                  text: 'PH',
                ),
                Tab(
                  text: 'PPM',
                ),
                Tab(
                  text: 'SUHU',
                ),
                Tab(
                  text: 'HUMID',
                ),
              ],
            ),
            title: const Text('Grafik'),
          ),
          body: const TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              ChartBuilder(
                SensorType: 'PH',
              ),
              ChartBuilder(
                SensorType: 'PPM',
              ),
              ChartBuilder(
                SensorType: 'TEMPERATURE',
              ),
              ChartBuilder(
                SensorType: 'HUMIDITY',
              ),
            ],
          ),
        ),
      ),
      //  body: GraphWidget(chartData: chartData),
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
  int timestamp1 = DateTime.now().millisecondsSinceEpoch;
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
          //print('>>>>>${widget.SensorType} >>>> $dataFetch');
        });
        constant.grafikData = snapshot.value as Map;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    ///print('BEFORE PASS TO CONSTRUCTOR ${dataFetch}');
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
  double findMaxNull = findMax ?? 0;
  double findLowNull = findMax ?? 0;
  @override
  Widget build(BuildContext context) {
    if (widget.dataFetch.isNotEmpty || true) {
      SensorHistoryList = [];

      //SORT MAP KEYS (Base Timestamp)
      var sortedKeys = widget.dataFetch.keys.toList()..sort();
      var reverseKey = sortedKeys.reversed;
      log('after ${sortedKeys.reversed}');

      var sortedMap = {
        for (var key in reverseKey) key: widget.dataFetch[key]!,
      };
      try {
        //
        if (sortedMap.isNotEmpty) {
          sortedMap.forEach(
            (k, v) {
              DateTime localDate = DateTime.fromMillisecondsSinceEpoch(
                int.parse(k) * 1000,
              ).toLocal();
              //add to graph list
              try {
                //add only current day
                var dateGraph =
                    DateTime.fromMillisecondsSinceEpoch(int.parse(k) * 1000);
                final now = DateTime.now();
                if (dateGraph.compareTo(now) == 0) {
                  double value = 0;
                  //print(localDate);
                  try {
                    double value = double.parse(v);
                    // find max
                    if (findMaxNull < value) {
                      print('>>  ${value.runtimeType}');
                      findMaxNull = value;
                    }
                    //Find Low
                    if (findLowNull > value || findLowNull == 0) {
                      findLowNull = value;
                      print(findLowNull);
                    }
                  } catch (e) {
                    // print('error double.parse(v)');
                    return;
                  }
                  SensorHistoryList.add(
                    SensorHistory(
                      localDate,
                      double.parse(v),
                    ),
                  );
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
              zoomPanBehavior: ZoomPanBehavior(
                enablePinching: true,
                enablePanning: true,
                zoomMode: ZoomMode.x,
              ),
              enableAxisAnimation: false,
              primaryXAxis: DateTimeAxis(
                  enableAutoIntervalOnZooming: true,
                  dateFormat: DateFormat.jms(),
                  borderColor: Colors.red,
                  labelStyle: TextStyle(
                    color: Colors.white,
                  )),
              primaryYAxis: NumericAxis(
                  minimum: findLowNull,
                  maximum: findMaxNull == 0 ? 100 : findMaxNull,
                  majorTickLines: const MajorTickLines(size: 0),
                  labelAlignment: LabelAlignment.end,
                  labelStyle: TextStyle(
                    color: Colors.white,
                  )),
              tooltipBehavior: TooltipBehavior(
                enable: true,
              ),
              plotAreaBackgroundColor: constant.cardButtonColor,
              borderColor: Colors.black,
              title: ChartTitle(
                textStyle: const TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.normal,
                ),
                text: 'Hari Ini',
              ),
              backgroundColor: constant.backgroundColor,
              series: <ChartSeries>[
                // Renders line chart
                LineSeries<SensorHistory, DateTime>(
                  enableTooltip: true,
                  xAxisName: 'time',
                  yAxisName: '${widget.SensorType} ',
                  color: Colors.white,
                  width: 2,
                  markerSettings: const MarkerSettings(
                    isVisible: true,
                    color: Colors.black,
                    shape: DataMarkerType.circle,
                    height: 6,
                    width: 6,
                  ),
                  dataSource: SensorHistoryList,
                  xValueMapper: (SensorHistory history, _) => history.unix,
                  yValueMapper: (SensorHistory history, _) =>
                      history.ValueSensor,
                )
              ],
            ),
          ),
        ),
        TextHighLow(
            maxVal: findMaxNull.toString(), minVal: findLowNull.toString())
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
        color: constant.cardColor,
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
