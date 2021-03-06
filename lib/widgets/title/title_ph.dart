import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:greenhouse/constant/constant.dart';
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
          const ParamPhWidget(type: 'set_ph'),
          const SizedBox(height: 20),
          const ParamPhWidget(type: 'set_mode_ph'),
          const SizedBox(height: 20),
          WidgetSetIntervalOnPh(),
          const SizedBox(height: 20),
          WidgetSetIntervalOffPh(),
        ],
      ),
    );
  }
}

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
                style: TextStyleTitleOutside,
              ),
              Text('atur ph target dan mode',
                  style: TextStyleSecondTitleOutside),
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

class ParamPhWidget extends StatelessWidget {
  const ParamPhWidget({
    Key? key,
    required this.type,
  });
  final String type;
  @override
  Widget build(BuildContext context) {
    String label = type == 'set_ph' ? 'TARGET' : 'MODE';
    String value = 'null';
    return StreamBuilder(
      stream: databaseRef.onValue,
      builder: (context, snapshot) {
        Sensor sensor = Sensor.fromSnapshotSetParameterStatus(snapshot);
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
              return BuildParamPh(
                label: label,
                type: type,
                value: value,
              );
            } else {
              return BuildParamPh(
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

//DIALOG INPUT PH TARGET
class BuildParamPh extends StatelessWidget {
  BuildParamPh({
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
    void showDialogMode(String _type) {
      String _targetPh = '';
      var alertSetPh = AlertDialog(
        backgroundColor: constant.backgroundColor,
        title: const Text(
          "pilih mode",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        content: Container(
          color: constant.backgroundColor,
          height: 130,
          child: Row(
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
                  InputDialog.validateVal(type, 'OTOMATIS', context);
                  Navigator.of(context, rootNavigator: true).pop();
                },
                child: const Text(
                  'OTOMATIS',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  InputDialog.validateVal(type, 'MANUAL', context);
                  Navigator.of(context, rootNavigator: true).pop();
                },
                child: const Text(
                  'MANUAL',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      );

      showDialog(
        context: context,
        builder: (context) {
          return alertSetPh;
        },
      );
    }

    void showDialogInput(String _type) {
      String _targetPh = '';
      var alertSetPh = AlertDialog(
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
                  _targetPh = value;
                },
                style: const TextStyle(
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
                    child: const Text(
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
          return alertSetPh;
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
                    showDialogInput(type);
                  } else {
                    showDialogMode(type);
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
      var alertSetPh = AlertDialog(
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
          return alertSetPh;
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
          try {
            final _intervalOn = int.parse(sensor.intervalOnPh!);
            intervalOnStr =
                '${(_intervalOn / 1000).toStringAsFixed(0).toString()} detik';
          } catch (e) {
            print('error [intervalOnPh] $e');
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

class WidgetSetIntervalOffPh extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void showDialogInput() {
      String _intervalOffPh = '';
      String maxIntervalOffPhStr =
          (constant.maxIntervalOffPh / 1000).toStringAsFixed(0);
      var alertSetPh = AlertDialog(
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
          return alertSetPh;
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
            print('${sensor.intervalOffPh}');
            final _intervalOn = int.parse(sensor.intervalOffPh!);
            intervalOffStr =
                '${(_intervalOn / 1000).toStringAsFixed(0).toString()} detik';
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
