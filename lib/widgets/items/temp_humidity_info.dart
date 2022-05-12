// import 'package:flutter/material.dart';
// import 'package:greenhouse/constant/constant.dart' as constant;
// import 'sensor_card.dart';

// class TempAndHumidity extends StatelessWidget {
//   const TempAndHumidity({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//     final double itemWidth = constant.width! / 2;
//     print('TempAndHumidity $itemWidth');
//     return Container(
//       height: constant.cardWitdh,
//       width: itemWidth,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           CardSensor(
//             iconVar: "assets/icon/icon_temperature.png",
//             textVar: "ROOM TEMPERATURE",
//             valuVar: "22.2",
//             unitVar: "°C",
//             bgColor: constant.bgColor,
//           ),
//           CardSensor(
//             iconVar: "assets/icon/icon_humidity.png",
//             textVar: "ROOM HUMIDITY",
//             valuVar: "22.0",
//             unitVar: "%",
//             bgColor: constant.bgColor,
//           ),
//         ],
//       ),
//     );
//   }
// }
