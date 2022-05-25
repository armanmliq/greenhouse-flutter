import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:greenhouse/constant/constant.dart' as constant;
import 'package:greenhouse/models/sensor.dart';
import 'package:greenhouse/widgets/items/show_modal_bottom.dart';

final databaseRef = FirebaseDatabase.instance
    .ref()
    .child('users')
    .child(constant.uid)
    .child("set_parameter");

class TitleSetSoil extends StatelessWidget {
  const TitleSetSoil({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: const [
          Text(
            'SMART IRIGASI',
            style: TextStyle(
              color: constant.titleTextColor,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              letterSpacing: 2,
            ),
          ),
          Text(
            'atur pompa irigasi berdasarkan kelembapan tanah dan mode lainnya',
            style: TextStyle(
              fontSize: 12,
              color: constant.secondTitleText,
            ),
          ),
        ],
      ),
    );
  }
}

class SetSoil extends StatelessWidget {
  const SetSoil({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      width: 350,
      height: constant.cardWitdh! * 1,
      borderRadius: constant.borderRadiusGlass,
      blur: 20,
      alignment: Alignment.bottomCenter,
      border: 2,
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
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: const [
                SetInput(
                  type: 'set_moisture_off',
                ),
                SetInput(
                  type: 'set_moisture_on',
                ),
                SizedBox(
                  height: 8,
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                SetInput(
                  type: 'set_mode_irigasi',
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                      width: 2,
                      color: Colors.white,
                    )),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('MANUAL MODE'),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  color: constant.cardButtonColor,
                                  child: TextButton(
                                      onPressed: () {},
                                      child: Text(
                                        'ON',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ))),
                              Container(
                                  color: constant.cardButtonColor,
                                  child: TextButton(
                                      onPressed: () {},
                                      child: Text(
                                        'OFF',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SetInput extends StatelessWidget {
  final String type;

  const SetInput({
    Key? key,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String infoText = '';
    String value = 'null';

    if (type == 'set_moisture_off') {
      infoText = 'batas atas moisture (irigasi nonaktif)';
    } else if (type == 'set_moisture_on') {
      infoText = 'batas bawah moisture (irigasi aktif)';
    } else if (type == 'set_mode_irigasi') {
      infoText = 'mode control';
    }
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            infoText,
            style: TextStyle(
              color: Colors.grey[50],
            ),
          ),
          StreamBuilder(
              stream: databaseRef.onValue,
              builder: (context, snapshotStream) {
                print('firing from SetInput $type');

                Sensor sensor =
                    Sensor.fromSnapshotSetParameterStatus(snapshotStream);
                late bool isDataNotError;
                BuildIrigasiWidget(type: type, value: value);
                value == 'null'
                    ? isDataNotError = false
                    : isDataNotError = true;
                if (snapshotStream.hasData) {
                  if (isDataNotError) {
                    sensor.CheckAndSave(type, value);
                  }
                  if (type == 'set_moisture_off') {
                    value = sensor.set_moisture_off.toString();
                  } else if (type == 'set_moisture_on') {
                    value = sensor.set_moisture_on.toString();
                  } else if (type == 'set_mode_irigasi') {
                    value = sensor.set_mode_irigasi.toString();
                    print('firing');
                  }
                }
                return FutureBuilder(
                  future: sensor.ReadInternalDataOf(type),
                  builder: ((context, snapshotFromInternal) {
                    if (value != 'null') {
                      sensor.CheckAndSave(type, value);
                      return BuildIrigasiWidget(type: type, value: value);
                    } else {
                      return BuildIrigasiWidget(
                        type: type,
                        value: snapshotFromInternal.data.toString(),
                      );
                    }
                  }),
                );
              }),
        ],
      ),
    );
  }
}

class BuildIrigasiWidget extends StatelessWidget {
  BuildIrigasiWidget({
    Key? key,
    required this.type,
    required this.value,
  }) : super(key: key);

  final String type;
  String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 60,
          height: 30,
          color: constant.cardButtonColor,
          child: TextButton(
            child: const Text(
              'UBAH',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () {
              print('11111 $value');
              print('222222 $value');
              if (type == 'set_mode_irigasi') {
                InputDialog.validateVal(type, value, context);
              } else {
                InputDialog.showModalInput(context, type);
              }
            },
          ),
        ),
        const SizedBox(
          width: 6,
        ),
        Expanded(
          child: Text(
            type == 'set_mode_irigasi' ? value.toUpperCase() : '$value%',
            style: TextStyle(
              color: Colors.white,
              fontSize: type == 'set_mode_irigasi' ? 14 : 23,
            ),
          ),
        ),
      ],
    );
  }
}

class IrigasiButtonManualMode extends StatefulWidget {
  const IrigasiButtonManualMode({Key? key}) : super(key: key);

  @override
  State<IrigasiButtonManualMode> createState() =>
      _IrigasiButtonManualModeState();
}

class _IrigasiButtonManualModeState extends State<IrigasiButtonManualMode> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: constant.backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              color: constant.cardButtonColor,
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  'On Irigasi',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'Off Irigasi',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
