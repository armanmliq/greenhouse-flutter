import 'package:flutter/material.dart';
import 'package:greenhouse/constant/constant.dart' as constant;
import 'package:greenhouse/widgets/items/grid_pompa.dart';
import 'package:greenhouse/widgets/items/grid_sensor.dart';
import 'package:greenhouse/widgets/title/title_status_pump.dart';
import '../constant/constant.dart';
import '../services/local_notification.dart';
import '../widgets/title/title_aktivitas.dart';
import '../widgets/title/title_control.dart';
import '../widgets/title/title_status_sensor.dart';

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
              ),
            ),
            Padding(
              padding: EdgeInsets.all(
                constant.padding,
              ),
              child: Column(
                children: const [
                  TitleRealtimeSensor(),
                  GridSensorStatus(),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(
                constant.padding,
              ),
              child: Column(
                children: const [
                  TitleAktifitas(),
                  AktifitasStatus(),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(
                constant.padding,
              ),
              child: Column(
                children: const [
                  TitlePompaStatus(),
                  GridPompaStatus(),
                ],
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.fromLTRB(constant.padding, 5, constant.padding, 0),
              child: Column(
                children: const [
                  TitleControlPompa(),
                ],
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.fromLTRB(constant.padding, 5, constant.padding, 0),
              child: Column(
                children: const [
                  controlPompa(),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                LocalNotification.showNotification(
                  'WARNING',
                  'PENGISIAN TANDON DIMULAI',
                );
              },
              child: const Text('NOTIFY'),
            )
          ],
        ),
      ),
    );
  }
}
