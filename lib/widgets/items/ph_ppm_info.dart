// import 'package:flutter/material.dart';
// import 'package:greenhouse/constant/constant.dart' as constant;
// import 'package:greenhouse/widgets/items/card_item.dart';
// import 'package:greenhouse/widgets/items/sensor_card.dart';

// late final padding = constant.padding;

// class PhPpm extends StatelessWidget {
//   const PhPpm({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//     final double itemWidth = constant.width! / 2;
//     print('TempAndHumidity $itemWidth');
//     return Container(
//       height: constant.cardWitdh,
//       width: itemWidth,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           CardSensor(
//             iconVar: 'assets/icon/icon_ph.png',
//             textVar: 'WATER PH',
//             valuVar: '6.6',
//             unitVar: 'Ph',
//             bgColor: constant.bgColor,
//           ),
//           CardSensor(
//             iconVar: 'assets/icon/icon_ppm.png',
//             textVar: 'WATER PPM',
//             valuVar: '1290',
//             unitVar: 'Ppm',
//             bgColor: constant.bgColor,
//           ),
//         ],
//       ),
//     );
//   }
// }
// // class PhPpm extends StatelessWidget {
// //   const PhPpm({Key? key}) : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     return Flexible(
// //       child: Container(
// //         height: constant.cardWitdh,
// //         child: Card(
// //           shadowColor: Colors.white,
// //           elevation: 3,
// //           shape: RoundedRectangleBorder(
// //             borderRadius: BorderRadius.circular(constant.borderRadius),
// //           ),
// //           color: constant.bgColor,
// //           child: Column(
// //             mainAxisAlignment: MainAxisAlignment.spaceAround,
// //             crossAxisAlignment: CrossAxisAlignment.stretch,
// //             children: [
// //               Row(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: [
// //                   Ph(),
// //                 ],
// //               ),
// //               Row(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: [
// //                   Ppm(),
// //                 ],
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class Ph extends StatelessWidget {
// //   const Ph({Key? key}) : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     return cardItem(
// //         iconVar: 'assets/icon/icon_ph.png',
// //         widthImage: 38,
// //         heightImage: 38,
// //         textVar: 'WATER PH',
// //         valuVar: '6.6',
// //         unitVar: 'Ph');
// //   }
// // }

// // class Ppm extends StatelessWidget {
// //   const Ppm({Key? key}) : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     return Padding(
// //       padding: EdgeInsets.fromLTRB(padding, 0, 0, 0),
// //       child: cardItem(
// //         iconVar: 'assets/icon/icon_ppm.png',
// //         widthImage: 38,
// //         heightImage: 38,
// //         textVar: 'WATER PPM',
// //         valuVar: '1290',
// //         unitVar: 'Ppm',
// //       ),
// //     );
// //   }
// // }
