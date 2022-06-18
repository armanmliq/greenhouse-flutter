import 'package:flutter/material.dart';
import '../../constant/constant.dart' as constant;
import '../../constant/constant.dart';

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
            children: [
              Text(
                'SENSOR REALTIME',
                style: TextStyleTitleOutside,
              ),
              const Text(
                'Update berbagai nilai sensor secara live',
                style: TextStyle(
                  fontSize: 15,
                  color: constant.secondTitleOutside,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
