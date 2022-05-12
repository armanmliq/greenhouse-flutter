import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:greenhouse/constant/constant.dart' as constant;
import 'package:greenhouse/models/sensor.dart';
import 'card_item.dart';

class SetParameter extends StatelessWidget {
  const SetParameter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Widget SetParameter');
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(constant.borderRadius),
      ),
      elevation: 3,
      color: constant.bgColor,
      shadowColor: constant.shadowColor,
      child: SizedBox(
        height: constant.cardWitdh! / 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                SetPpm(),
                SetHumidity(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SetPpm extends StatelessWidget {
  const SetPpm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalInput(context, 'PPM');
      },
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(constant.uid)
              .collection('set_parameter')
              .doc(constant.uid)
              .snapshots(),
          builder: (context, snapshot) {
            Sensor sensor = Sensor.fromSnapshotSetParameterStatus(snapshot);
            if (snapshot.hasData) {
              return cardItem(
                heightImage: 38,
                widthImage: 38,
                iconVar: 'assets/icon/icon_pump_nutrition.png',
                textVar: 'TARGET PPM',
                unitVar: 'click here to change',
                valuVar: sensor.setPpm.toString(),
              );
            } else {
              return const cardItem(
                heightImage: 38,
                widthImage: 38,
                iconVar: 'assets/icon/icon_pump_nutrition.png',
                textVar: 'TARGET PPM',
                unitVar: 'click here to change',
                valuVar: 'no data',
              );
            }
          }),
    );
  }
}

class SetHumidity extends StatelessWidget {
  const SetHumidity({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalInput(context, 'HUMIDITY');
      },
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(constant.uid)
            .collection('set_parameter')
            .doc(constant.uid)
            .snapshots(),
        builder: (context, snapshot) {
          Sensor sensor = Sensor.fromSnapshotSetParameterStatus(snapshot);
          if (snapshot.hasData) {
            print("BUILD SETHUMIDITY");
            return cardItem(
              heightImage: 38,
              widthImage: 38,
              iconVar: 'assets/icon/icon_humidity.png',
              textVar: 'TARGET HUMIDITY',
              unitVar: 'click here to change',
              valuVar: sensor.setHumidity.toString(),
            );
          } else {
            return const cardItem(
              heightImage: 38,
              widthImage: 38,
              iconVar: 'assets/icon/icon_humidity.png',
              textVar: 'TARGET HUMIDITY',
              unitVar: 'click here to change',
              valuVar: 'no data',
            );
          }
        },
      ),
    );
  }
}

void showModalInput(BuildContext context, String type) {
  final _controllerValue = TextEditingController();

  showModalBottomSheet(
    context: context,
    barrierColor: Colors.transparent,
    backgroundColor: Colors.white,
    elevation: 10,
    builder: (BuildContext context) {
      return SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: TextFormField(
                controller: _controllerValue,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  label: Text('SET $type'),
                ),
              ),
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      try {
                        print(_controllerValue.text);
                        final doc = FirebaseFirestore.instance
                            .collection('users')
                            .doc(constant.uid)
                            .collection('set_parameter')
                            .doc(constant.uid);
                        if (type == "PPM") {
                          doc.update({
                            'set_ppm': _controllerValue.text,
                          });
                        }
                        if (type == "HUMIDITY") {
                          doc.update({
                            'set_humidity': _controllerValue.text,
                          });
                        }
                      } catch (er) {}
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('CANCEL'),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}
