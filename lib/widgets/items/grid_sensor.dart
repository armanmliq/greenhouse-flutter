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
          textVar: 'ph',
          unitVar: 'pH',
          bgColor: constant.cardColor,
        ),
        CardSensor(
          type: 'ppm',
          iconVar: 'assets/icon/icon_ppm.png',
          textVar: 'tds',
          unitVar: 'PPM',
          bgColor: constant.cardColor,
        ),
        CardSensor(
          type: 'temperature',
          iconVar: "assets/icon/icon_temperature.png",
          textVar: "suhu\nruangan",
          unitVar: "°C",
          bgColor: constant.cardColor,
        ),
        CardSensor(
          type: 'temperatureWater',
          iconVar: "assets/icon/icon_temperature.png",
          textVar: "suhu\nair",
          unitVar: "°C",
          bgColor: constant.cardColor,
        ),
        CardSensor(
          type: 'humidity',
          iconVar: "assets/icon/icon_humidity.png",
          textVar: "kelemb\napan",
          unitVar: "%",
          bgColor: constant.cardColor,
        ),
        CardSensor(
          type: 'pompaPenyiraman',
          iconVar: 'assets/icon/icon_pump.png',
          textVar: 'pompa\npenyiraman',
          unitVar: '',
          bgColor: constant.cardColor,
        ),
        CardSensor(
          type: 'pompa_status',
          iconVar: 'assets/icon/icon_pump.png',
          textVar: 'pompa \ntandon',
          unitVar: '',
          bgColor: constant.cardColor,
        ),
        CardSensor(
          type: 'pompa_nutrisi_status',
          iconVar: 'assets/icon/icon_pump_nutrition.png',
          textVar: 'pompa\nabmix up',
          unitVar: '',
          bgColor: constant.cardColor,
        ),
        CardSensor(
          type: 'pompaPhUpStatus',
          iconVar: 'assets/icon/icon_pump_nutrition.png',
          textVar: 'pompa\nph up',
          unitVar: '',
          bgColor: constant.cardColor,
        ),
        CardSensor(
          type: 'pompaPhDownStatus',
          iconVar: 'assets/icon/icon_pump_nutrition.png',
          textVar: 'pompa\nph down',
          unitVar: '',
          bgColor: constant.cardColor,
        ),
      ],
    );
  }
}
