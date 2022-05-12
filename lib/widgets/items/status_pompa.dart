import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:greenhouse/constant/constant.dart' as constant;
import 'package:greenhouse/models/sensor.dart';
import 'card_item.dart';

class ControlInformation extends StatelessWidget {
  const ControlInformation({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    print('BUILDING ControlInformation');
    return SizedBox(
      height: 150,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(constant.borderRadius),
        ),
        elevation: 3,
        color: constant.bgColor,
        shadowColor: constant.shadowColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                PumpStatus(),
                DosingPumpStatus(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PumpStatus extends StatelessWidget {
  const PumpStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(constant.uid!)
            .collection('control_status')
            .doc(constant.uid!)
            .snapshots(),
        builder: (context, snapshot) {
          Sensor sensor = Sensor.fromSnapshotControlStatus(snapshot);
          if (snapshot.hasData) {
            return cardItem(
              heightImage: 38,
              widthImage: 38,
              iconVar: 'assets/icon/icon_pump.png',
              textVar: 'POMPA AIR',
              unitVar: 'STATUS',
              valuVar: sensor.pompa_status!,
            );
          } else {
            return const cardItem(
              heightImage: 38,
              widthImage: 38,
              iconVar: 'assets/icon/icon_pump.png',
              textVar: 'POMPA AIR',
              unitVar: 'STATUS',
              valuVar: 'NO DATA',
            );
          }
        });
  }
}

class DosingPumpStatus extends StatelessWidget {
  const DosingPumpStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(constant.uid)
          .collection('control_status')
          .doc(constant.uid)
          .snapshots(),
      builder: (context, snapshot) {
        Sensor sensor = Sensor.fromSnapshotControlStatus(snapshot);
        if (snapshot.hasData) {
          return cardItem(
            heightImage: 38,
            widthImage: 38,
            iconVar: 'assets/icon/icon_pump_nutrition.png',
            textVar: 'POMPA NUTRISI',
            unitVar: 'STATUS',
            valuVar: sensor.pompa_nutrisi_status!,
          );
        } else {
          return const cardItem(
            heightImage: 38,
            widthImage: 38,
            iconVar: 'assets/icon/icon_pump_nutrition.png',
            textVar: 'POMPA NUTRISI',
            unitVar: 'STATUS',
            valuVar: 'ON',
          );
        }
      },
    );
  }
}
