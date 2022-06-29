import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:greenhouse/models/sensor.dart';
import 'package:greenhouse/constant/constant.dart' as constant;
import 'package:intl/intl.dart';

class cardItem extends StatelessWidget {
  final String iconVar;
  final double widthImage;
  final double heightImage;
  final String textVar;
  late String valuVar;
  final String unitVar;
  final String type;

  cardItem({
    required this.type,
    required this.iconVar,
    required this.widthImage,
    required this.heightImage,
    required this.textVar,
    required this.valuVar,
    required this.unitVar,
  });

  @override
  Widget build(BuildContext context) {
    return CardContentItem(
      type: type,
      textVar: textVar,
      widthImage: widthImage,
      heightImage: heightImage,
      iconVar: iconVar,
      valuVar: valuVar,
      unitVar: unitVar,
    );
  }
}

class CardContentItem extends StatelessWidget {
  const CardContentItem({
    Key? key,
    required this.type,
    required this.textVar,
    required this.widthImage,
    required this.heightImage,
    required this.iconVar,
    required this.valuVar,
    required this.unitVar,
  }) : super(key: key);

  final String textVar;
  final double widthImage;
  final double heightImage;
  final String iconVar;
  final String valuVar;
  final String unitVar;
  final String type;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          children: [
            risingOrFalling(
              type: type,
              valuVar: valuVar,
            ),
            SizedBox(
              width: widthImage,
              height: heightImage,
              child:
                  Image.asset(iconVar, width: widthImage, height: heightImage),
            ),
            Text(textVar,
                style: const TextStyle(
                    color: constant.cardTitleColor, fontSize: 13)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 3),

                    //build widget for value
                    ValueInfoWidget(valuVar: valuVar, type: type),

                    Text(
                      unitVar,
                      style: const TextStyle(
                          fontSize: 12, color: constant.cardTextUnitColor),
                    )
                  ],
                ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(' ',
                            style: TextStyle(
                              fontSize: 9,
                              color: constant.CardLastChangeUpdateTextColor,
                            )),
                        //build lastchange info widget
                        LastChangeInfoWidget(
                          valuVar: valuVar,
                          type: type,
                        )
                      ],
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ],
    );
  }
}

double trendValue = 0;

class risingOrFalling extends StatelessWidget {
  risingOrFalling({required this.type, required this.valuVar});
  final String type;
  final String valuVar;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Sensor().ReadInternalDataOf(type),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          saveTrend(snapshot, trendValue);
          if (valuVar.contains('HIDUP') ||
              valuVar.contains('MATI') ||
              valuVar.contains('null')) {
            trendValue = 0;
          } else {
            log('[READTRENDB]  valu: $valuVar trend: $trendValue');
            trendValue = calculateTrend(snapshot, trendValue);
          }
          log('[READTREND]  valu: $valuVar trend: $trendValue $type');
        }
        if (trendValue == 0) {
          return Container();
        } else {
          return Column(
            children: [
              trendValue > 0
                  ? const Icon(
                      Icons.arrow_circle_up_sharp,
                      color: Colors.green,
                      size: 15,
                    )
                  : const Icon(
                      Icons.arrow_circle_down_sharp,
                      color: Colors.red,
                      size: 15,
                    ),
              Text(
                trendValue > 0
                    ? (trendValue).toStringAsFixed(1).toString()
                    : (trendValue * -1).toStringAsFixed(1).toString(),
                style: TextStyle(
                  color: trendValue > 0 ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          );
        }
      },
    );
  }

  Future<void> saveTrend(
      AsyncSnapshot<Object?> snapshot, double trendValue) async {
    try {
      trendValue = calculateTrend(snapshot, trendValue);
      await Sensor().CheckAndSave('${type}Trend', trendValue.toString());
    } catch (e) {
      log('[trend]error $e');
    }
  }

  double calculateTrend(AsyncSnapshot<Object?> snapshot, double trendValue) {
    print('[calculateTrend]$valuVar');
    double valueSekarang = 0;
    double valueSebelum = 0;
    try {
      valueSekarang = double.parse(valuVar);
    } catch (e) {}
    try {
      valueSebelum = double.parse(snapshot.data.toString());
    } catch (e) {}
    trendValue = valueSekarang - valueSebelum;
    return trendValue;
  }
}

class ValueInfoWidget extends StatelessWidget {
  const ValueInfoWidget({
    Key? key,
    required this.valuVar,
    required this.type,
  }) : super(key: key);

  final String valuVar;
  final String type;

  @override
  Widget build(BuildContext context) {
    late Color valueColor;
    if (valuVar.contains('HIDUP')) {
      valueColor = Colors.green;
    } else if (valuVar.contains('MATI')) {
      valueColor = Colors.red;
    } else {
      valueColor = Colors.white;
    }
    final sensor = Sensor();
    late bool isDataNotError;
    valuVar == 'null' ? isDataNotError = false : isDataNotError = true;
    if (isDataNotError) {
      Sensor().CheckAndSave(type, valuVar);
      print('[ValueInfoWidget] $valuVar $type');
      return Text(
        valuVar,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: valueColor,
          fontSize: constant.GridValueTextSize,
        ),
      );
    } else {
      //readValue info widget
      return FutureBuilder(
        future: sensor.ReadInternalDataOf(type),
        builder: (context, AsyncSnapshot<String> snapshot) {
          print('[ValueInfoWidget > FutureBuilder] $type ::: ${snapshot.data}');
          if (snapshot.hasData) {
            return Text(
              snapshot.data!,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: constant.GridValueTextColor,
                fontSize: constant.GridValueTextSize,
              ),
            );
          } else {
            return const Text(
              '-.-',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: constant.GridValueTextColor,
                fontSize: constant.GridValueTextSize,
              ),
            );
          }
        },
      );
    }
  }
}

class LastChangeInfoWidget extends StatelessWidget {
  LastChangeInfoWidget({
    Key? key,
    required this.type,
    required this.valuVar,
  }) : super(key: key);

  final String type;
  final String valuVar;

  @override
  Widget build(BuildContext context) {
    print('[LastChangeInfoWidget] $type $valuVar');
    return FutureBuilder(
      future: Sensor().isDataDifferent(type, valuVar),
      builder: (context, AsyncSnapshot<bool> isDifferent) {
        if (isDifferent.hasData) {
          isDifferent.data! ? dateTimeNowText() : dateTimeFromInternalText();
        }
        return dateTimeFromInternalText();
      },
    );
  }

  final f = DateFormat('yyyy-MM-dd  hh:mm');

  Widget dateTimeNowText() {
    final DateTime lastChange = DateTime.now();
    final text = f.format(lastChange).toString();
    return Text(
      text,
      style: const TextStyle(
          fontSize: 9, color: constant.CardLastChangeUpdateTextColor),
    );
  }

  Widget dateTimeFromInternalText() {
    return FutureBuilder(
      future: Sensor().ReadInternalDataOf('${type}UpdateTime'),
      builder: (context, AsyncSnapshot<String> snapshot) {
        print('[ReadInternalDataOf] ${snapshot.data} $type');
        if (snapshot.hasData && snapshot.data != 'null') {
          final date = DateTime.parse(snapshot.data!);
          final text = f.format(date).toString();
          return Text(
            text,
            style: const TextStyle(
              fontSize: 9,
              color: constant.CardLastChangeUpdateTextColor,
            ),
          );
        } else {
          return dateTextError();
        }
      },
    );
  }

  Widget dateTextError() {
    return const Text('-.-', style: TextStyle(fontSize: 9));
  }
}
