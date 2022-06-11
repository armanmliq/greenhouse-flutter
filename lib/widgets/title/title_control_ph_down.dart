import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:greenhouse/constant/constant.dart' as constant;
import 'package:greenhouse/constant/constant.dart';
import 'package:greenhouse/services/ServiceFirebase.dart';

import '../../models/sensor.dart';

class TitleControlPhDown extends StatefulWidget {
  const TitleControlPhDown({Key? key}) : super(key: key);

  @override
  State<TitleControlPhDown> createState() => _TitleControlPhDownState();
}

class _TitleControlPhDownState extends State<TitleControlPhDown> {
  @override
  void initState() {
    FirebaseService.getStatusPompaPhDown();
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
                  'ph down',
                  style: TextStyleTitleTitle,
                ),
                const Text(
                  'control pompa \nph down (manual)',
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
                      FirebaseService.SetPompaPhDown();
                      print('stateButtonPhDown ${constant.stateButtonPhDown}');
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
                        .child('set_pompa_ph_down')
                        .onValue,
                    builder: (context, snapshot) {
                      final sensor =
                          Sensor.fromSnapshotStateButtonPhDown(snapshot);
                      return Text(
                        constant.stateButtonPhDown == true ? 'ON' : 'OFF',
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
