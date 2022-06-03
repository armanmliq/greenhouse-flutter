import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:greenhouse/models/sensor.dart';
import '../../constant/constant.dart' as constant;
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
        height: 280,
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
            height: 20,
          ),
          const Text(
            'MANUAL MODE',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(
            height: 10,
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
    String label = type == 'set_ppm' ? 'TARGET' : 'MODE';
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
    void showDialogInput() {
      String _targetPh = '';
      var alert = AlertDialog(
        backgroundColor: constant.backgroundColor,
        title: const Text(
          "Berapa target ppm? \n maximum ${constant.maxPpm}",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        content: Container(
          color: constant.backgroundColor,
          height: 100,
          child: Column(
            children: [
              TextField(
                keyboardType: TextInputType.number,
                maxLines: 1,
                autofocus: false,
                enabled: true,
                onChanged: (String value) {
                  _targetPh = value;
                },
                onSubmitted: (String value) {
                  print('submitted');
                  _targetPh = value;
                },
                style: TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  errorStyle: const TextStyle(color: Colors.redAccent),
                  border: UnderlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  disabledBorder: UnderlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  prefixIcon: const Icon(
                    Icons.confirmation_number_sharp,
                    size: 18.0,
                    color: Colors.white,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    child: Text(
                      'CANCEL',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      print(' _targetPh  $_targetPh');
                      InputDialog.validateVal(type, _targetPh, context);
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    child: Text(
                      'OK',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

      showDialog(
        context: context,
        builder: (context) {
          return alert;
        },
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: constant.titleTextColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
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
                    showDialogInput();
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
