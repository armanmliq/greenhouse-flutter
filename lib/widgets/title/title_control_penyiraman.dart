import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:greenhouse/constant/constant.dart' as constant;
import 'package:greenhouse/constant/constant.dart';
import 'package:greenhouse/services/ServiceFirebase.dart';

import '../../models/sensor.dart';

class TitleControlPenyiraman extends StatefulWidget {
  const TitleControlPenyiraman({Key? key}) : super(key: key);

  @override
  State<TitleControlPenyiraman> createState() => _TitleControlPenyiramanState();
}

class _TitleControlPenyiramanState extends State<TitleControlPenyiraman> {
  @override
  void initState() {
    FirebaseService.getStatusPompaPenyiraman();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: constant.cardColor,
      elevation: 5,
      child: Padding(
        padding: EdgeInsets.all(constant.padding),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'penyiraman',
                  style: TextStyleTitleTitle,
                ),
                const Text(
                  'control pompa\n penyiraman (manual)',
                  //              constant.stateButtonPenyiramaan == true ? 'STATUS:HIDUP' : 'STATUS:MATI',
                  style: TextStyle(
                    fontSize: 13,
                    color: constant.secondTitleText,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Container(
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.all(Radius.circular(constant.borderRadius)),
                color: constant.BackgroundCardButtonColor,
              ),
              child: TextButton.icon(
                icon: const Icon(
                  Icons.water,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(
                    () {
                      FirebaseService.SetPompaPenyiraman();
                      print(
                          'stateButtonPenyiramaan ${constant.stateButtonPenyiramaan}');
                    },
                  );
                },
                label: Align(
                  alignment: Alignment.bottomCenter,
                  child: StreamBuilder<Object>(
                    stream: FirebaseDatabase.instance
                        .ref()
                        .child('users')
                        .child(constant.uid)
                        .child('set_parameter')
                        .child('set_pompa_penyiraman')
                        .onValue,
                    builder: (context, snapshot) {
                      final sensor =
                          Sensor.fromSnapshotStateButtonPenyiraman(snapshot);
                      return Text(
                        constant.stateButtonPenyiramaan == true ? 'ON' : 'OFF',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      );
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
