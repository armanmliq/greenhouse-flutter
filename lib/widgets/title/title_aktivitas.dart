import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import "package:flutter/material.dart";
import 'package:glassmorphism/glassmorphism.dart';
import 'package:greenhouse/constant/constant.dart' as constant;
import 'package:greenhouse/models/sensor.dart';
import 'package:greenhouse/services/local_notification.dart';
import 'package:intl/intl.dart';

List<Widget> listAktifitas = [];

final refAktifitas = FirebaseDatabase.instance
    .ref()
    .child('users')
    .child(constant.uid)
    .child('grafik')
    .child('aktifitas')
    .onValue;

class TitleAktifitas extends StatelessWidget {
  const TitleAktifitas({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Aktifitas',
                style: constant.TextStyleTitleTitle,
              ),
              const Text(
                'Monitor aktifitas alat secara Realtime',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AktifitasStatus extends StatelessWidget {
  const AktifitasStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScrollController _scrollController = ScrollController();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GlassmorphicContainer(
        width: double.infinity,
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
        blur: 20,
        alignment: Alignment.bottomCenter,
        border: 2,
        borderRadius: constant.borderRadius,
        height: 400,
        child: StreamBuilder(
          stream: refAktifitas,
          builder: (context, snap) {
            if (snap.hasData) {
              _scrollController = ScrollController(
                initialScrollOffset: 0,
              );
              //get data from snap
              final _sensor = Sensor.fromSnapshotAktifitas(snap);
              listAktifitas.clear();

              //get map from sensor class
              final _rawAktifitas = _sensor.rawAktifitas;

              //SORT MAP KEYS (Base Timestamp)
              var sortedKeys = _rawAktifitas.keys.toList()..sort();
              var reverseKey = sortedKeys;

              var sortedMap = {
                for (var key in reverseKey) key: _rawAktifitas[key]!,
              };

              sortedMap.forEach(
                (key, value) {
                  //take time and value from for each
                  var f = DateFormat('HH:mm');
                  var epoch = int.parse(key);
                  var date = DateTime.fromMillisecondsSinceEpoch(
                    epoch * 1000,
                  );
                  String _time = f.format(date);
                  String _text = ' [$_time]  $value';
                  log('unix : $date');
                  if (date.day == DateTime.now().day) {
                    //add listAktifitas
                    listAktifitas.add(
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            color: Colors.transparent,
                            child: Text(
                              _text,
                              style: const TextStyle(
                                color: Colors.amber,
                                fontSize: 9,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                            ),
                          ),
                          const SizedBox(
                            height: 4,
                          )
                        ],
                      ),
                    );
                  }
                },
              );
            }
            return SingleChildScrollView(
              controller: _scrollController,
              reverse: true,
              child: Padding(
                padding: EdgeInsets.all(constant.padding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: listAktifitas,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
