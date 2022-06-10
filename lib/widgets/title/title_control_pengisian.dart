import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:greenhouse/constant/constant.dart' as constant;
import 'package:greenhouse/services/ServiceFirebase.dart';

import '../../constant/constant.dart';
import '../../models/sensor.dart';

class TitleControlPengisian extends StatefulWidget {
  const TitleControlPengisian({Key? key}) : super(key: key);

  @override
  State<TitleControlPengisian> createState() => _TitleControlPengisianState();
}

class _TitleControlPengisianState extends State<TitleControlPengisian> {
  @override
  void initState() {
    FirebaseService.getStatusPompaPengisian();
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
                  'pengisian',
                  style: TextStyleTitleTitle,
                ),
                const Text(
                  'control pompa \npengisian tandon (manual)',
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
                      FirebaseService.SetPompaPengisian();
                      print(
                          'stateButtonPengisian ${constant.stateButtonPengisian}');
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
                          .child('set_pompa_pengisian')
                          .onValue,
                      builder: (context, snapshot) {
                        final sensor =
                            Sensor.fromSnapshotStateButtonPengisian(snapshot);
                        return Text(
                          constant.stateButtonPengisian == true ? 'ON' : 'OFF',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        );
                      }),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
