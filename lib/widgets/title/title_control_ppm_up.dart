import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:greenhouse/constant/constant.dart' as constant;
import 'package:greenhouse/services/ServiceFirebase.dart';

import '../../constant/constant.dart';
import '../../models/sensor.dart';

class TitleControlPpmUp extends StatefulWidget {
  const TitleControlPpmUp({Key? key}) : super(key: key);

  @override
  State<TitleControlPpmUp> createState() => _TitleControlPpmUpState();
}

class _TitleControlPpmUpState extends State<TitleControlPpmUp> {
  @override
  void initState() {
    FirebaseService.getStatusPompaPpmUp();
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
                  'ppm up',
                  style: TextStyleTitleTitle,
                ),
                Text(
                  'control pompa \nppm up (manual)',
                  //constant.stateButtonPenyiramaan == true ? 'STATUS:HIDUP' : 'STATUS:MATI',
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
                      FirebaseService.SetPompaPpmUp();
                      print('stateButtonPpmUp ${constant.stateButtonPpmUp}');
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
                        .child('set_pompa_ppm_up')
                        .onValue,
                    builder: (context, snapshot) {
                      final sensor =
                          Sensor.fromSnapshotStateButtonPpmUp(snapshot);
                      return Text(
                        constant.stateButtonPpmUp == true ? 'ON' : 'OFF',
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
