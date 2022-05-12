import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenhouse/constant/constant.dart' as constant;

class TitleRealtimeSensor extends StatelessWidget {
  const TitleRealtimeSensor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Status Sensor',
              style: GoogleFonts.heebo(
                color: constant.titleTextColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                letterSpacing: 2,
              ),
            ),
            const Text(
              'Menampilkan Status Sensor Secara Realtime',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
