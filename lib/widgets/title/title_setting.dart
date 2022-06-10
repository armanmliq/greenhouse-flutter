import 'package:flutter/material.dart';
import 'package:greenhouse/constant/constant.dart' as constant;

import '../../constant/constant.dart';

class TitleSet extends StatelessWidget {
  const TitleSet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //  Card(
    //   color: Colors.blue,
    //   elevation: 5,
    //   child: Padding(
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('SET VALUE', style: TextStyleTitleTitle),
              Text(
                'ganti value target yang diinginkan',
                style: TextStyle(
                  fontSize: 12,
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
