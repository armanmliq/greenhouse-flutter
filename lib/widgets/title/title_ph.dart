import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:greenhouse/models/sensor.dart';
import '../../constant/constant.dart' as constant;
import '../items/show_modal_bottom.dart';

double fontSize = 14;
bool isValidate = false;
final databaseRef = FirebaseDatabase.instance
    .ref()
    .child('users')
    .child(constant.uid)
    .child("set_parameter");

class TitleSetPh extends StatelessWidget {
  const TitleSetPh({Key? key}) : super(key: key);

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
                'PH',
                style: TextStyle(
                  color: constant.titleTextColor,
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize,
                  letterSpacing: 2,
                ),
              ),
              Text(
                'atur ph target dan mode',
                style: TextStyle(
                  fontSize: fontSize,
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

class SetParameterPh extends StatelessWidget {
  const SetParameterPh({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Widget SetParameter');
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

class TargetPhWidget extends StatelessWidget {
  const TargetPhWidget({
    Key? key,
    required this.type,
  }) : super(key: key);
  final String type;
  @override
  Widget build(BuildContext context) {
    String label = type == 'set_ph' ? 'TARGET' : 'MODE';
    String value = 'null';
    return StreamBuilder(
      stream: databaseRef.onValue,
      builder: (context, snapshot) {
        Sensor sensor = Sensor.fromSnapshotSetParameterStatus(snapshot);
        print('firing from TargetPhWidget');
        if (snapshot.hasData) {
          value = type == 'set_ph'
              ? sensor.set_ph.toString()
              : sensor.set_mode_ph.toString();
          print('Get >>> $value');
        }
        return FutureBuilder(
          future: sensor.ReadInternalDataOf(type),
          builder: ((context, snapshotFromInternal) {
            if (value != 'null') {
              sensor.CheckAndSave(type, value);
              return BuildTargetPhWidget(
                  label: label, type: type, value: value);
            } else {
              return BuildTargetPhWidget(
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

class SettingParameter extends StatelessWidget {
  const SettingParameter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(constant.padding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TargetPhWidget(type: 'set_ph'),
          const SizedBox(height: 20),
          const TargetPhWidget(type: 'set_mode_ph'),
          const SizedBox(height: 20),
          WidgetSetIntervalOnPh(),
          WidgetSetIntervalOffPh(),
        ],
      ),
    );
  }
}

class BuildTargetPhWidget extends StatelessWidget {
  BuildTargetPhWidget({
    Key? key,
    required this.label,
    required this.type,
    required this.value,
  }) : super(key: key);

  final String label;
  final String type;
  final String value;
  final textControl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    void showDialogInput() {
      String _targetPh = '';
      var alert = AlertDialog(
        backgroundColor: constant.backgroundColor,
        title: const Text(
          "masukan target ph? \n maximum ${constant.maxPh}",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        content: Container(
          color: constant.backgroundColor,
          height: 130,
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
                controller: textControl,
                decoration: InputDecoration(
                  errorStyle: const TextStyle(color: Colors.redAccent),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.white,
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.white,
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.white,
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  prefixIcon: const Icon(
                    Icons.confirmation_num,
                    color: Colors.white,
                    size: 18.0,
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
          style: TextStyle(
            color: constant.titleTextColor,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            Container(
              width: 60,
              height: 40,
              color: constant.BackgroundCardButtonColor,
              child: TextButton(
                onPressed: () {
                  if (type == 'set_ph') {
                    showDialogInput();
                  } else {
                    InputDialog.validateVal(type, value, context);
                  }
                },
                child: Text(
                  type == 'set_ph' ? 'UBAH' : 'UBAH',
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
              style: TextStyle(
                color: constant.titleTextColor,
                fontSize: fontSize,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class WidgetSetIntervalOnPh extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void showDialogInput() {
      String _intervalOnPh = '';
      String maxIntervalOnPhStr =
          (constant.maxIntervalOnPh / 1000).toStringAsFixed(0);
      var alert = AlertDialog(
        backgroundColor: constant.backgroundColor,
        title: Text(
          "masukan interval \nuntuk pompa on ph\nmaks $maxIntervalOnPhStr Detik",
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        content: Container(
          color: constant.backgroundColor,
          height: 130,
          child: Column(
            children: [
              TextField(
                keyboardType: TextInputType.number,
                maxLines: 1,
                autofocus: false,
                enabled: true,
                onChanged: (String value) {
                  _intervalOnPh = value;
                },
                onSubmitted: (String value) {
                  _intervalOnPh = value;
                },
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  errorStyle: const TextStyle(color: Colors.redAccent),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.white,
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.white,
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.white,
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  prefixIcon: const Icon(
                    Icons.confirmation_num,
                    color: Colors.white,
                    size: 18.0,
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
                    child: const Text(
                      'CANCEL',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      print(' _intervalOnPh  $_intervalOnPh');
                      InputDialog.validateVal(
                        'set_interval_on_ph',
                        _intervalOnPh,
                        context,
                      );
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    child: const Text(
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

    String intervalOnStr = "";
    return StreamBuilder(
      stream: databaseRef.onValue,
      builder: ((context, snapshot) {
        final sensor = Sensor.fromSnapshotSetParameterStatus(snapshot);
        print('${sensor.intervalOnPh}');
        if (snapshot.hasData) {
          final _intervalOn = int.parse(sensor.intervalOnPh!);
          intervalOnStr =
              '${(_intervalOn / 1000).toStringAsFixed(0).toString()} detik';
        }
        String label = "INTERVAL ON";
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: constant.titleTextColor,
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                Container(
                  color: constant.BackgroundCardButtonColor,
                  child: TextButton(
                    onPressed: () {
                      showDialogInput();
                    },
                    child: const Text(
                      'UBAH',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 9),
                Text(
                  intervalOnStr,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}

class WidgetSetIntervalOffPh extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void showDialogInput() {
      String _intervalOffPh = '';
      String maxIntervalOffPhStr =
          (constant.maxIntervalOffPh / 1000).toStringAsFixed(0);
      var alert = AlertDialog(
        backgroundColor: constant.backgroundColor,
        title: Text(
          "masukan interval \nuntuk pompa off ph\nmaks $maxIntervalOffPhStr Detik",
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        content: Container(
          color: constant.backgroundColor,
          height: 130,
          child: Column(
            children: [
              TextField(
                keyboardType: TextInputType.number,
                maxLines: 1,
                autofocus: false,
                enabled: true,
                onChanged: (String value) {
                  _intervalOffPh = value;
                },
                onSubmitted: (String value) {
                  _intervalOffPh = value;
                },
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  errorStyle: const TextStyle(color: Colors.redAccent),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.white,
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.white,
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.white,
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  prefixIcon: const Icon(
                    Icons.confirmation_num,
                    color: Colors.white,
                    size: 18.0,
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
                    child: const Text(
                      'CANCEL',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      print(' _intervalOffPh  $_intervalOffPh');
                      InputDialog.validateVal(
                        'set_interval_off_ph',
                        _intervalOffPh,
                        context,
                      );
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    child: const Text(
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

    String intervalOffStr = "";
    return StreamBuilder(
      stream: databaseRef.onValue,
      builder: ((context, snapshot) {
        final sensor = Sensor.fromSnapshotSetParameterStatus(snapshot);
        print('${sensor.intervalOffPh}');
        if (snapshot.hasData) {
          final _intervalOn = int.parse(sensor.intervalOffPh!);
          intervalOffStr =
              '${(_intervalOn / 1000).toStringAsFixed(0).toString()} detik';
        }
        String label = "INTERVAL OFF";
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: constant.titleTextColor,
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                Container(
                  color: constant.BackgroundCardButtonColor,
                  child: TextButton(
                    onPressed: () {
                      showDialogInput();
                    },
                    child: const Text(
                      'UBAH',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 9),
                Text(
                  intervalOffStr,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}
