import 'package:flutter/material.dart';
import 'package:greenhouse/widgets/items/sensor_card.dart';
import 'package:greenhouse/constant/constant.dart' as constant;

class GridLiveData extends StatelessWidget {
  const GridLiveData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const GridGenerator();
  }
}

class GridGenerator extends StatelessWidget {
  const GridGenerator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics:
          const NeverScrollableScrollPhysics(), // to disable GridView's scrolling
      childAspectRatio: 2.2 / 2,
      crossAxisCount: 2,
// humidity
// tankLevel
// ppm
// ph
// sprayer_status
// pompa_nutrisi_status
// pompa_status
// temperature
      children: const [
        CardSensor(
          type: 'ph',
          iconVar: 'assets/icon/icon_ph.png',
          textVar: 'PH',
          unitVar: 'PH',
          bgColor: constant.cardColor,
        ),
        CardSensor(
          type: 'ppm',
          iconVar: 'assets/icon/icon_ppm.png',
          textVar: 'TDS',
          unitVar: 'PPM',
          bgColor: constant.cardColor,
        ),
        CardSensor(
          type: 'temperature',
          iconVar: "assets/icon/icon_temperature.png",
          textVar: "SUHU",
          unitVar: "°C",
          bgColor: constant.cardColor,
        ),
        CardSensor(
          type: 'humidity',
          iconVar: "assets/icon/icon_humidity.png",
          textVar: "KELEM\nBAPAN",
          unitVar: "%",
          bgColor: constant.cardColor,
        ),
        // CardSensor(
        //   type: "tankLevel",
        //   iconVar: "assets/icon/icon_water_level.png",
        //   textVar: "TANDON\nLEVEL",
        //   unitVar: "%",
        //   bgColor: constant.cardColor,
        // ),
        CardSensor(
          type: 'pompa_status',
          iconVar: 'assets/icon/icon_pump.png',
          textVar: 'POMPA \nTANK',
          unitVar: '',
          bgColor: constant.cardColor,
        ),
        CardSensor(
          type: 'pompa_nutrisi_status',
          iconVar: 'assets/icon/icon_pump_nutrition.png',
          textVar: 'POMPA\nAB MIX',
          unitVar: '',
          bgColor: constant.cardColor,
        ),
        CardSensor(
          type: 'sprayer_status',
          iconVar: 'assets/icon/icon_sprayer.png',
          textVar: 'SPRAYER',
          unitVar: '',
          bgColor: constant.cardColor,
        ),
      ],
    );
  }
}
