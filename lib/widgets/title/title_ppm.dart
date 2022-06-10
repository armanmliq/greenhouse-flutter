import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:greenhouse/models/sensor.dart';
import '../../constant/constant.dart' as constant;
import '../../constant/constant.dart';
import '../items/show_modal_bottom.dart';

double fontSize = 14;
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
        height: 350,
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
            children: [
              Text(
                'NUTRISI',
                style: TextStyleTitleTitle,
              ),
              Text(
                'atur target nutrisi dan mode',
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

class SettingParameter extends StatelessWidget {
  const SettingParameter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(constant.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const WidgetSetTargetPpm(type: 'set_ppm'),
          const SizedBox(height: 20),
          const WidgetSetTargetPpm(type: 'set_mode_ppm'),
          const SizedBox(height: 20),
          WidgetSetIntervalOnPpm(),
          const SizedBox(height: 20),
          WidgetSetIntervalOffPpm(),
        ],
      ),
    );
  }
}

class WidgetSetIntervalOffPpm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void showDialogInput() {
      String _intervalOffPpm = '';
      String maxIntervalOffPpmStr =
          (constant.maxIntervalOffPpm / 1000).toStringAsFixed(0);
      var alert = AlertDialog(
        backgroundColor: constant.backgroundColor,
        title: Text(
          "masukan interval \nuntuk pompa ppm\nmaks $maxIntervalOffPpmStr Detik",
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
                  _intervalOffPpm = value;
                },
                onSubmitted: (String value) {
                  _intervalOffPpm = value;
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
                      print(' _intervalOffPpm  $_intervalOffPpm');
                      InputDialog.validateVal(
                          'set_interval_off_ppm', _intervalOffPpm, context);
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
        if (snapshot.hasData) {
          try {
            final sensor = Sensor.fromSnapshotSetParameterStatus(snapshot);
            final _intervalOff = int.parse(sensor.intervalOffPpm!);
            intervalOffStr =
                '${(_intervalOff / 1000).toStringAsFixed(0).toString()} detik';
          } catch (e) {
            print(e.toString());
          }
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

class WidgetSetIntervalOnPpm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void showDialogInput() {
      String _intervalOnPpm = '';
      String maxIntervalOnPpmStr =
          (constant.maxIntervalOnPpm / 1000).toStringAsFixed(0);
      var alert = AlertDialog(
        backgroundColor: constant.backgroundColor,
        title: Text(
          "masukan interval \nuntuk pompa ppm\nmaks $maxIntervalOnPpmStr Detik",
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
                  _intervalOnPpm = value;
                },
                onSubmitted: (String value) {
                  _intervalOnPpm = value;
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
                      print(' _intervalOnPpm  $_intervalOnPpm');
                      InputDialog.validateVal(
                          'set_interval_on_ppm', _intervalOnPpm, context);
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
        if (snapshot.hasData) {
          try {
            final _intervalOn = int.parse(sensor.intervalOnPpm!);
            intervalOnStr =
                '${(_intervalOn / 1000).toStringAsFixed(0).toString()} detik';
          } catch (e) {
            print(e.toString());
          }
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

class WidgetSetTargetPpm extends StatelessWidget {
  const WidgetSetTargetPpm({
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
        if (snapshot.hasData) {
          value = type == 'set_ppm'
              ? sensor.set_ppm.toString()
              : sensor.set_mode_ppm.toString();
        }
        return FutureBuilder(
          future: sensor.ReadInternalDataOf(type),
          builder: ((context, snapshotFromInternal) {
            if (value != 'null') {
              sensor.CheckAndSave(type, value);
              return BuildWidgetSetPpm(label: label, type: type, value: value);
            } else {
              return BuildWidgetSetPpm(
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

class BuildWidgetSetPpm extends StatelessWidget {
  const BuildWidgetSetPpm({
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
      String _intervalOnPpm = '';
      var alert = AlertDialog(
        backgroundColor: constant.backgroundColor,
        title: const Text(
          "masukan target ppm \n maximum ${constant.maxPpm}",
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
                  _intervalOnPpm = value;
                },
                onSubmitted: (String value) {
                  _intervalOnPpm = value;
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
                      print(' _intervalOnPpm  $_intervalOnPpm');
                      InputDialog.validateVal(type, _intervalOnPpm, context);
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
            const SizedBox(width: 9),
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
