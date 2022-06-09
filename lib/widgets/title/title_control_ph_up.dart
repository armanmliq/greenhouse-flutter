import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:greenhouse/constant/constant.dart' as constant;
import 'package:greenhouse/services/ServiceFirebase.dart';

import '../../models/sensor.dart';

class TitleControlPhUp extends StatefulWidget {
  const TitleControlPhUp({Key? key}) : super(key: key);

  @override
  State<TitleControlPhUp> createState() => _TitleControlPhUpState();
}

class _TitleControlPhUpState extends State<TitleControlPhUp> {
  @override
  void initState() {
    FirebaseService.getStatusPompaPhUp();
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
              children: const [
                Text(
                  'ph up',
                  style: TextStyle(
                    color: constant.titleTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    letterSpacing: 2,
                  ),
                ),
                Text(
                  'control pompa \nph up (manual)',
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
                      log("message");

                      FirebaseService.SetPompaPhUp();
                      print('stateButtonPhUp ${constant.stateButtonPhUp}');
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
                        .child('set_pompa_ph_up')
                        .onValue,
                    builder: (context, snapshot) {
                      final sensor =
                          Sensor.fromSnapshotStateButtonPhUp(snapshot);
                      return Text(
                        constant.stateButtonPhUp == true ? 'ON' : 'OFF',
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
