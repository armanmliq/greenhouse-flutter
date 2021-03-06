import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:greenhouse/constant/constant.dart' as constant;

import '../../constant/constant.dart';
import '../../screens/jadwal_ppm.dart';

bool _stateButton = false;
final databaseRef = FirebaseDatabase.instance
    .ref()
    .child('users')
    .child(constant.uid)
    .child("sensor_status");

class TitleJadwalPpm extends StatefulWidget {
  const TitleJadwalPpm({Key? key}) : super(key: key);

  @override
  State<TitleJadwalPpm> createState() => TitleJadwalPpmState();
}

class TitleJadwalPpmState extends State<TitleJadwalPpm> {
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
                  'Jadwal \nnutrisi',
                  style: TextStyleTitleTitle,
                ),
                const Text(
                  'Atur jadwal \nnutrisi',
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
                icon: const Icon(Icons.timer, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return JadwalPpmScreen();
                      },
                    ),
                  );
                },
                label: const Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    'setting',
                    style: TextStyle(
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
