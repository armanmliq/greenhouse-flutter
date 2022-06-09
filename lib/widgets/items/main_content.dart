import 'package:flutter/material.dart';
import 'package:greenhouse/constant/constant.dart' as constant;
import 'package:greenhouse/widgets/title/title_control_ph_down.dart';
import 'package:greenhouse/widgets/title/title_control_ph_up.dart';
import 'package:greenhouse/widgets/title/title_ph.dart';
import 'package:greenhouse/widgets/items/grid_sensor.dart';
import 'package:greenhouse/widgets/title/title_ppm.dart';
import '../../constant/constant.dart';
import '../title/title_control_pengisian.dart';
import '../title/title_control_penyiraman.dart';
import '../title/title_control_ppm_up.dart';
import '../title/title_grafik.dart';
import '../title/title_jadwal_penyiraman.dart';
import '../title/title_jadwal_ppm.dart';
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
                child: Container(
                  height: 120.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(borderRadiusGlass),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/greenhouse.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                )),
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
                  TitleControlPpmUp(),
                ],
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.fromLTRB(constant.padding, 5, constant.padding, 0),
              child: Column(
                children: const [
                  TitleControlPhDown(),
                ],
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.fromLTRB(constant.padding, 5, constant.padding, 0),
              child: Column(
                children: const [
                  TitleControlPhUp(),
                ],
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.fromLTRB(constant.padding, 5, constant.padding, 0),
              child: Column(
                children: const [
                  TitleControlPengisian(),
                ],
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.fromLTRB(constant.padding, 5, constant.padding, 0),
              child: Column(
                children: const [
                  TitleControlPenyiraman(),
                ],
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.fromLTRB(constant.padding, 5, constant.padding, 0),
              child: Column(
                children: const [
                  TitleJadwalPenyiraman(),
                ],
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.fromLTRB(constant.padding, 5, constant.padding, 0),
              child: Column(
                children: const [
                  TitleJadwalPpm(),
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
          ],
        ),
      ),
    );
  }
}
