import 'package:flutter/material.dart';
import 'package:greenhouse/constant/constant.dart';
import '../widgets/title/title_ph.dart';
import '../widgets/title/title_ppm.dart';

class setPointScreen extends StatelessWidget {
  const setPointScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          title: const Text('Setting'),
          automaticallyImplyLeading: true,
        ),
        body: ListView(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: const [
                      TitleSetPh(),
                      SetParameterPh(),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(padding, 5, padding, 0),
                  child: Column(
                    children: const [
                      TitleSetPpm(),
                      SetParameterPpm(),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
