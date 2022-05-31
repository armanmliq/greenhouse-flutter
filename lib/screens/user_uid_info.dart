import 'package:flutter/material.dart';
import 'package:greenhouse/constant/constant.dart';
import 'package:greenhouse/constant/constant.dart' as constant;

class UidInfoScreen extends StatelessWidget {
  const UidInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Your ID:',
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(
              height: 12,
            ),
            Center(child: SelectableText(constant.uid)),
          ],
        ),
      ),
    );
  }
}