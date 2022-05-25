import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:greenhouse/models/sensor.dart';
import '../../constant/constant.dart' as constant;
import '../../screens/ppm_datetime_picker.dart';
import '../../services/ServiceFirebase.dart';
import '../items/show_modal_bottom.dart';

bool isValidate = false;
final databaseRef = FirebaseDatabase.instance
    .ref()
    .child('users')
    .child(constant.uid)
    .child("set_parameter");

class SetParameterPpm extends StatelessWidget {
  const SetParameterPpm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Widget SetParameterPpm');
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GlassmorphicContainer(
        width: double.infinity,
        linearGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFffffff).withOpacity(0.1),
              const Color(0xFFFFFFFF).withOpacity(0.05),
            ],
            stops: const [
              0.1,
              1,
            ]),
        borderGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFffffff).withOpacity(0.5),
            const Color((0xFFFFFFFF)).withOpacity(0.5),
          ],
        ),
        blur: 20,
        alignment: Alignment.bottomCenter,
        border: 2,
        borderRadius: constant.borderRadius,
        height: 300,
        child: Row(
          children: const [
            SettingParameter(),
          ],
        ),
      ),
    );
  }
}

class TitleSetPpm extends StatelessWidget {
  const TitleSetPpm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'SETTING PPM',
                style: TextStyle(
                  color: constant.titleTextColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  letterSpacing: 2,
                ),
              ),
              Text(
                'atur setting untuk ppm target dan mode',
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

class SettingParameter extends StatelessWidget {
  const SettingParameter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(constant.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TargetPpmWidget(type: 'set_ppm'),
          const SizedBox(
            height: 4,
          ),
          const TargetPpmWidget(type: 'set_mode_ppm'),
          const SizedBox(
            height: 10,
          ),
          const Text(
            'Manual',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const Text(
            'PPM UP',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          Row(
            children: [
              Container(
                color: constant.cardButtonColor,
                child: TextButton(
                  onPressed: () {
                    FirebaseService.OnOffPpm('on');
                  },
                  child: const Text(
                    'ON',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Container(
                color: constant.cardButtonColor,
                child: TextButton(
                  onPressed: () {
                    FirebaseService.OnOffPpm('off');
                  },
                  child: const Text(
                    'OFF',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            width: MediaQuery.of(context).size.width * 0.6,
            color: constant.cardButtonColor,
            child: TextButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: ((context) {
                  return JadwalPpmScreen();
                })));
              },
              child: const Text(
                'Atur Jadwal',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TargetPpmWidget extends StatelessWidget {
  const TargetPpmWidget({
    Key? key,
    required this.type,
  }) : super(key: key);
  final String type;
  @override
  Widget build(BuildContext context) {
    String label = type == 'set_ppm' ? 'target ppm' : 'mode control';
    String value = 'null';
    return StreamBuilder(
      stream: databaseRef.onValue,
      builder: (context, snapshot) {
        Sensor sensor = Sensor.fromSnapshotSetParameterStatus(snapshot);
        print('firing from TargetPpmWidget');
        if (snapshot.hasData) {
          value = type == 'set_ppm'
              ? sensor.set_ppm.toString()
              : sensor.set_mode_ppm.toString();
          print('Get >>> $value');
        }
        return FutureBuilder(
          future: sensor.ReadInternalDataOf(type),
          builder: ((context, snapshotFromInternal) {
            if (value != 'null') {
              sensor.CheckAndSave(type, value);
              return BuildTargetPpmWidget(
                  label: label, type: type, value: value);
            } else {
              return BuildTargetPpmWidget(
                label: label,
                type: type,
                value: snapshotFromInternal.data.toString(),
              );
            }
          }),
        );
      },
    );
  }
}

class BuildTargetPpmWidget extends StatelessWidget {
  const BuildTargetPpmWidget({
    Key? key,
    required this.label,
    required this.type,
    required this.value,
  }) : super(key: key);

  final String label;
  final String type;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: constant.titleTextColor,
            fontSize: 12,
          ),
        ),
        Row(
          children: [
            Container(
              width: 60,
              height: 40,
              color: constant.cardButtonColor,
              child: TextButton(
                onPressed: () {
                  if (type.contains('mode')) {
                    InputDialog.validateVal(type, value, context);
                  } else {
                    InputDialog.showModalInput(context, type);
                  }
                },
                child: Text(
                  type == 'set_ppm' ? 'UBAH' : 'UBAH',
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 9,
            ),
            Text(
              value,
              style: const TextStyle(
                color: constant.titleTextColor,
                fontSize: 23,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
