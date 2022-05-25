import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:greenhouse/models/sensor.dart';
import 'package:greenhouse/screens/graph_screen.dart';
import 'package:greenhouse/widgets/items/card_item.dart';
import '../../constant/constant.dart' as constant;
import '';

final databaseRef = FirebaseDatabase.instance
    .ref()
    .child('users')
    .child(constant.uid)
    .child("sensor_status");

String valuVar = '';
bool? isOnOff = constant.SprayerButton;
late bool isControl;
bool MatiApaHidup(String state) {
  isControl = true;
  if (state.contains('HIDUP') || state.contains('ON')) {
    return true;
  } else {
    return false;
  }
}

class CardSensor extends StatelessWidget {
  const CardSensor({
    required this.type,
    required this.iconVar,
    required this.textVar,
    required this.unitVar,
    required this.bgColor,
  });
  final String type;
  final String iconVar;
  final String textVar;
  final String unitVar;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    ShowGraph(String type) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => Graph1()));
    }

    print('BUILD CARDSENSOR');
    return StreamBuilder(
      stream: databaseRef.onValue,
      builder: (context, snapshot) {
        print(snapshot.data);
        Sensor sensor = Sensor.fromSnapshotSensorStatus(snapshot);
        if (type.contains("POMPA STATUS")) {
          isOnOff = MatiApaHidup(sensor.pompa_status.toString());
        } else if (type.contains("POMPA NUTRISI")) {
          isOnOff = MatiApaHidup(sensor.pompa_nutrisi_status.toString());
        } else if (type.contains("SPRAYER")) {
          isOnOff = MatiApaHidup(sensor.sprayer_status.toString());
        } else {
          isControl = false;
        }

        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: GlassmorphicContainer(
            border: 2,
            width: double.infinity,
            height: double.infinity,
            blur: 20,
            linearGradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFFffffff).withOpacity(0.1),
                  const Color(0xFFFFFFFF).withOpacity(0.05),
                ],
                stops: const [
                  0.1,
                  1,
                ]),
            borderGradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFFffffff).withOpacity(0.5),
                const Color((0xFFFFFFFF)).withOpacity(0.5),
              ],
            ),
            // shadowColor: constant.shadowColor,
            // elevation: 3,
            borderRadius: constant.borderRadiusGlass,

            child: InkWell(
              onTap: () => ShowGraph(type),
              child: CardContent(
                type: type,
                iconVar: iconVar,
                textVar: textVar,
                unitVar: unitVar,
                sensor: sensor,
              ),
            ),
          ),
        );
      },
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
    String dateString = '';
    if (type == 'humidity') {
      valuVar = sensor.humidity.toString();
    } else if (type == 'tankLevel') {
      valuVar = sensor.tankLevel.toString();
    } else if (type == 'ppm') {
      valuVar = sensor.ppm.toString();
    } else if (type == 'ph') {
      valuVar = sensor.ph.toString();
    } else if (type == 'sprayer_status') {
      valuVar = sensor.sprayer_status.toString();
    } else if (type == 'pompa_nutrisi_status') {
      valuVar = sensor.pompa_nutrisi_status.toString();
    } else if (type == 'pompa_status') {
      valuVar = sensor.pompa_status.toString();
    } else if (type == 'temperature') {
      valuVar = sensor.temperature.toString();
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            cardItem(
              type: type,
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
