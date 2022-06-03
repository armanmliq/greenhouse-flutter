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
            children: const [
              Text(
                'SETTING PH',
                style: TextStyle(
                  color: constant.titleTextColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  letterSpacing: 2,
                ),
              ),
              Text(
                'atur setting untuk ph target dan mode',
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

class TextInfoPpm extends StatefulWidget {
  const TextInfoPpm({Key? key}) : super(key: key);

  @override
  State<TextInfoPpm> createState() => _TextInfoPpmState();
}

class _TextInfoPpmState extends State<TextInfoPpm> {
  @override
  Widget build(BuildContext context) {
    return Container();
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
        children: const [
          TargetPhWidget(type: 'set_ph'),
          SizedBox(
            height: 4,
          ),
          TargetPhWidget(type: 'set_mode_ph'),
          SizedBox(
            height: 10,
          ),
          Text(
            'MANUAL MODE',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'PH UP',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          ph_up(),
          SizedBox(
            height: 10,
          ),
          Text(
            'PH DOWN',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          ph_down(),
        ],
      ),
    );
  }
}

class ph_up extends StatelessWidget {
  const ph_up({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Row(
        children: [
          Container(
            color: constant.cardButtonColor,
            child: TextButton(
              onPressed: () {
                FirebaseService.OnOffPhUp('on');
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
                FirebaseService.OnOffPhUp('off');
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
    );
  }
}

class ph_down extends StatelessWidget {
  const ph_down({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Row(
        children: [
          Container(
            color: constant.cardButtonColor,
            child: TextButton(
              onPressed: () {
                FirebaseService.OnOffPhDown('on');
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
                FirebaseService.OnOffPhDown('off');
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

class BuildTargetPhWidget extends StatelessWidget {
  const BuildTargetPhWidget({
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
                  if (type == 'set_ph') {
                    InputDialog.showModalInput(context, type);
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
