import 'package:flutter/material.dart';
import 'package:greenhouse/constant/constant.dart' as constant;
import 'package:greenhouse/widgets/title/title_ph.dart';
import 'package:greenhouse/widgets/items/grid_sensor.dart';
import 'package:greenhouse/widgets/title/title_ppm.dart';

import '../title/title_grafik.dart';
import '../title/title_irigasi.dart';
import '../title/title_jadwal_penyiraman.dart';
import '../title/title_setting.dart';
import '../title/title_spray.dart';
import '../title/title_status_sensor.dart';

class MainContent extends StatelessWidget {
  const MainContent({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(constant.padding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(
                constant.padding,
              ),
              child: Column(
                children: const [
                  TitleRealtimeSensor(),
                  GridLiveData(),
                ],
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.fromLTRB(constant.padding, 5, constant.padding, 0),
              child: Column(
                children: const [
                  TitleSetSoil(),
                  SetSoil(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: const [
                  TitleSetPh(),
                  SetParameterPh(),
                ],
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.fromLTRB(constant.padding, 5, constant.padding, 0),
              child: Column(
                children: const [
                  TitleSetPpm(),
                  SetParameterPpm(),
                ],
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.fromLTRB(constant.padding, 5, constant.padding, 0),
              child: Column(
                children: const [
                  TitleChart(),
                ],
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.fromLTRB(constant.padding, 5, constant.padding, 0),
              child: Column(
                children: const [
                  TitleSpray(),
                ],
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.fromLTRB(constant.padding, 5, constant.padding, 0),
              child: Column(
                children: const [
                  TitleJadwal(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
