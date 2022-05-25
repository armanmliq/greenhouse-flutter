import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:greenhouse/constant/constant.dart' as constant;

bool _stateButton = false;
final databaseRef = FirebaseDatabase.instance
    .ref()
    .child('users')
    .child(constant.uid)
    .child("sensor_status");

class TitleSpray extends StatefulWidget {
  const TitleSpray({Key? key}) : super(key: key);

  @override
  State<TitleSpray> createState() => _TitleSprayState();
}

void _UpdateSprayerStatus() {
  print('_UpdateSprayerStatus $_stateButton');
  databaseRef.update(
    {'sprayer_status': _stateButton ? 'HIDUP' : 'MATI'},
  );
}

class _TitleSprayState extends State<TitleSpray> {
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
                  'SPRAYER',
                  style: TextStyle(
                    color: constant.titleTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    letterSpacing: 2,
                  ),
                ),
                Text(
                  'atur sprayer \nsecara realtime',
                  //              _stateButton == true ? 'STATUS:HIDUP' : 'STATUS:MATI',
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
                color: constant.ColorMati,
              ),
              child: TextButton.icon(
                icon: const Icon(
                  Icons.air,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(
                    () {
                      _UpdateSprayerStatus();
                      _stateButton = !_stateButton;
                      print('_stateButton $_stateButton');
                    },
                  );
                },
                label: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    _stateButton == true ? 'hidupkan' : 'matikan',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
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
