import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenhouse/constant/constant.dart' as constant;
import 'package:greenhouse/screens/graph_screen.dart';

class TitleChart extends StatelessWidget {
  const TitleChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //  Card(
    //   color: Colors.blue,
    //   elevation: 5,
    //   child: Padding(
    return Card(
      elevation: 5,
      color: constant.cardColor,
      child: Padding(
        padding: EdgeInsets.all(constant.padding),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'GRAFIK',
                  style: TextStyle(
                    color: constant.titleTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    letterSpacing: 2,
                  ),
                ),
                Text(
                  'Laporan grafik informasi\ndari sensor ',
                  style: TextStyle(
                    fontSize: 12,
                    color: constant.secondTitleText,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Container(
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.all(Radius.circular(constant.borderRadius)),
                color: constant.ColorMati,
              ),
              child: TextButton.icon(
                icon: const Icon(
                  Icons.leaderboard,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: ((context) => Graph1())));
                },
                label: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    'lihat',
                    style: GoogleFonts.heebo(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
