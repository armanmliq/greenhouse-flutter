import 'package:flutter/material.dart';
import '../../constant/constant.dart' as constant;

class TitleRealtimeSensor extends StatelessWidget {
  const TitleRealtimeSensor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'SENSOR REALTIME',
                style: TextStyle(
                  color: constant.titleTextColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  letterSpacing: 2,
                ),
              ),
              Text(
                'Menampilkan status sensor secara realtime',
                style: TextStyle(
                  fontSize: 15,
                  color: constant.secondTitleText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
