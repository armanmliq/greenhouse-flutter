import 'package:flutter/material.dart';
import 'package:greenhouse/widgets/items/sensor_card.dart';
import 'package:greenhouse/constant/constant.dart' as constant;

class GridLiveData extends StatelessWidget {
  const GridLiveData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics:
          const NeverScrollableScrollPhysics(), // to disable GridView's scrolling
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,

      crossAxisCount: 2,
      children: [
        CardSensor(
          type: 'PH',
          iconVar: 'assets/icon/icon_ph.png',
          textVar: 'PH AIR',
          valuVar: '6.6',
          unitVar: 'Ph',
          bgColor: constant.bgColor,
        ),
        CardSensor(
          type: 'PPM',
          iconVar: 'assets/icon/icon_ppm.png',
          textVar: 'PPM AIR',
          valuVar: '1290',
          unitVar: 'Ppm',
          bgColor: constant.bgColor,
        ),
        CardSensor(
          type: 'TEMPERATURE',
          iconVar: "assets/icon/icon_temperature.png",
          textVar: "SUHU RUANGAN",
          valuVar: "22.2",
          unitVar: "°C",
          bgColor: constant.bgColor,
        ),
        CardSensor(
          type: 'HUMIDITY',
          iconVar: "assets/icon/icon_humidity.png",
          textVar: "KELEMBAPAN \nRUANGAN",
          valuVar: "22.0",
          unitVar: "%",
          bgColor: constant.bgColor,
        ),
        CardSensor(
          type: "LEVEL OF TANK",
          iconVar: "assets/icon/icon_water_level.png",
          textVar: "LEVEL AIR TANGKI",
          valuVar: "48",
          unitVar: "%",
          bgColor: constant.bgColor,
        ),
      ],
    );
  }
}
