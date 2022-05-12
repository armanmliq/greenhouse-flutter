import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:greenhouse/constant/constant.dart' as constant;
import 'package:greenhouse/models/sensor.dart';
import 'package:greenhouse/services/auth.dart';
import 'package:greenhouse/widgets/items/card_item.dart';
import 'package:provider/provider.dart';
import 'package:greenhouse/services/firebase.dart';

class CardSensor extends StatelessWidget {
  CardSensor({
    required this.type,
    required this.iconVar,
    required this.textVar,
    required this.valuVar,
    required this.unitVar,
    required this.bgColor,
  });
  final String type;
  final String iconVar;
  final String textVar;
  final String valuVar;
  final String unitVar;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    print('CardSensor ${constant.cardWitdh}');
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shadowColor: constant.shadowColor,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(constant.borderRadius),
        ),
        color: bgColor,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            constant.padding,
            constant.padding,
            constant.padding,
            constant.padding,
          ),
          child: StreamBuilder(
            stream: FirebaseService().recentJobsRef.onValue,
            builder: (context, snap) {
              Sensor sensor = Sensor.fromSnapshotSensorStatus(snap);
              if (snap.hasData && !snap.hasError && snap.data != null) {
                return CardContent(
                  type: type,
                  iconVar: iconVar,
                  textVar: textVar,
                  unitVar: unitVar,
                  sensor: sensor,
                );
              } else {
                return CardContent(
                  type: '0',
                  iconVar: iconVar,
                  textVar: 'null',
                  unitVar: unitVar,
                  sensor: sensor,
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class CardContent extends StatelessWidget {
  const CardContent({
    Key? key,
    required this.type,
    required this.iconVar,
    required this.textVar,
    required this.unitVar,
    required this.sensor,
  }) : super(key: key);

  final String type;
  final String iconVar;
  final String textVar;
  final String unitVar;
  final Sensor sensor;

  @override
  Widget build(BuildContext context) {
    String valuVar = '';
    if (type == 'PH') {
      valuVar = sensor.ph.toString();
    } else if (type == 'PPM') {
      valuVar = sensor.ppm.toString();
    } else if (type == 'TEMPERATURE') {
      valuVar = sensor.temperature.toString();
    } else if (type == 'HUMIDITY') {
      valuVar = sensor.humidity.toString();
    } else if (type == 'LEVEL OF TANK') {
      valuVar = sensor.tankLevel.toString();
    } else if (type == 'NODATA') {
      valuVar = '0';
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            cardItem(
              heightImage: constant.height! / 21,
              widthImage: constant.width! / 9.47,
              iconVar: iconVar,
              textVar: textVar,
              unitVar: unitVar,
              valuVar: valuVar,
            ),
          ],
        ),
      ],
    );
  }
}
