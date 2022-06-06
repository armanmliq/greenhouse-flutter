import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:greenhouse/constant/constant.dart' as constant;
import 'package:greenhouse/services/ServiceFirebase.dart';

final databaseRef = FirebaseDatabase.instance
    .ref()
    .child('users')
    .child(constant.uid)
    .child("sensor_status");

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
              children: const [
                Text(
                  'Penyiraman',
                  style: TextStyle(
                    color: constant.titleTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    letterSpacing: 2,
                  ),
                ),
                Text(
                  'control \npompa penyiraman',
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
                      constant.stateButtonPenyiramaan =
                          !constant.stateButtonPenyiramaan;
                      FirebaseService.SetPompaPenyiraman(
                          constant.stateButtonPenyiramaan);
                      print(
                          'stateButtonPenyiramaan ${constant.stateButtonPenyiramaan}');
                    },
                  );
                },
                label: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    constant.stateButtonPenyiramaan == true
                        ? 'matikan'
                        : 'dihupkan',
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
