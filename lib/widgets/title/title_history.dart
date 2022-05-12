import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenhouse/constant/constant.dart' as constant;

import '../items/homescreen_graph.dart';

class TitleChart extends StatelessWidget {
  const TitleChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Grafik Histori',
              style: GoogleFonts.heebo(
                color: constant.titleTextColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                letterSpacing: 2,
              ),
            ),
            const Text(
              'Menampilkan informasi histori \ngrafik dari sensor ',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        const Spacer(),
        TextButton.icon(
          icon: const Icon(
            Icons.leaderboard,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: ((context) => GraphSensor())));
          },
          label: Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              'more \ngraph',
              style: GoogleFonts.heebo(
                color: constant.titleTextColor,
                fontWeight: FontWeight.bold,
                fontSize: 10,
                letterSpacing: 2,
              ),
            ),
          ),
        )
      ],
    );
  }
}
