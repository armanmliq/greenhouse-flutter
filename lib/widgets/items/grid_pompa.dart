import 'package:flutter/material.dart';
import 'package:greenhouse/widgets/items/sensor_card.dart';
import 'package:greenhouse/constant/constant.dart' as constant;

class GridPompaStatus extends StatelessWidget {
  const GridPompaStatus({Key? key}) : super(key: key);

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
      children: const [
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
