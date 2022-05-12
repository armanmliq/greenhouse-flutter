import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class cardItem extends StatelessWidget {
  final String iconVar;
  final double widthImage;
  final double heightImage;
  final String textVar;
  final String valuVar;
  final String unitVar;

  const cardItem({
    required this.iconVar,
    required this.widthImage,
    required this.heightImage,
    required this.textVar,
    required this.valuVar,
    required this.unitVar,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          textVar,
          style: GoogleFonts.aBeeZee(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: widthImage,
              height: heightImage,
              child: Image.asset(
                iconVar,
                width: widthImage,
                height: heightImage,
              ),
            ),
            const SizedBox(
              width: 4,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 8),
                Text(
                  valuVar,
                  style: const TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  unitVar,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )
          ],
        ),
      ],
    );
  }
}
