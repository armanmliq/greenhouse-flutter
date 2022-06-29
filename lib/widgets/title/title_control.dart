import 'package:firebase_database/firebase_database.dart';
import "package:flutter/material.dart";
import 'package:glassmorphism/glassmorphism.dart';
import 'package:greenhouse/constant/constant.dart' as constant;
import "package:flutter_switch/flutter_switch.dart";

import '../../models/sensor.dart';
import '../../services/ServiceFirebase.dart';

class TitleControlPompa extends StatelessWidget {
  const TitleControlPompa({Key? key}) : super(key: key);

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
                'Kontrol Pompa',
                style: constant.TextStyleTitleTitle,
              ),
              const Text(
                'Kontrol Pompa Secara manual',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class controlPompa extends StatelessWidget {
  const controlPompa({Key? key}) : super(key: key);

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
        height: 400,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            controlPompaItem(
              parameterName: 'set_pompa_ph_up',
              stateButton: constant.stateButtonPhUp,
              buttonName: "DOSING PH UP",
            ),
            const SizedBox(
              height: 10,
            ),
            controlPompaItem(
              parameterName: 'set_pompa_ph_down',
              stateButton: constant.stateButtonPhDown,
              buttonName: "DOSING PH DOWN",
            ),
            const SizedBox(
              height: 10,
            ),
            controlPompaItem(
              parameterName: 'set_pompa_ppm_up',
              stateButton: constant.stateButtonPpmUp,
              buttonName: "DOSING ABMIX",
            ),
            const SizedBox(
              height: 10,
            ),
            controlPompaItem(
              parameterName: 'set_pompa_penyiraman',
              stateButton: constant.stateButtonPenyiramaan,
              buttonName: "PENYIRAMAN",
            ),
            const SizedBox(
              height: 10,
            ),
            controlPompaItem(
              parameterName: 'set_pompa_pengisian',
              stateButton: constant.stateButtonPengisian,
              buttonName: "PENGISIAN TANDON",
            ),
            const SizedBox(
              height: 10,
            ),
            controlPompaItem(
              parameterName: 'set_sprayer',
              stateButton: constant.stateButtonSprayer,
              buttonName: "SPRAYER",
            ),
          ],
        ),
      ),
    );
  }
}

bool status = false;

class controlPompaItem extends StatefulWidget {
  controlPompaItem({
    required this.parameterName,
    required this.stateButton,
    required this.buttonName,
  });
  final String parameterName;
  final bool stateButton;
  final String buttonName;

  @override
  State<controlPompaItem> createState() => _controlPompaItemState();
}

class _controlPompaItemState extends State<controlPompaItem> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(
          width: 10,
        ),
        StreamBuilder<Object>(
          stream: FirebaseDatabase.instance
              .ref()
              .child('users')
              .child(constant.uid)
              .child('set_parameter')
              .child(widget.parameterName)
              .onValue,
          builder: (context, snapshot) {
            final sensor = Sensor.fromSnapshotStateButtonPhUp(snapshot);
            return Container(
              child: FlutterSwitch(
                width: 70,
                activeColor: constant.backgroundColor,
                height: 55,
                valueFontSize: 15,
                toggleSize: 25.0,
                value: constant.stateButtonPhUp,
                borderRadius: constant.borderRadius,
                padding: 2.0,
                showOnOff: true,
                onToggle: (val) {
                  setState(
                    () {
                      if (widget.buttonName.contains('PH UP')) {
                        FirebaseService.SetPompaPhUp();
                      } else if (widget.buttonName.contains('PH DOWN')) {
                        FirebaseService.SetPompaPhDown();
                      } else if (widget.buttonName.contains('ABMIX')) {
                        FirebaseService.SetPompaPpmUp();
                      } else if (widget.buttonName.contains('PENYIRAMAN')) {
                        FirebaseService.SetPompaPenyiraman();
                      } else if (widget.buttonName.contains('PENGISIAN')) {
                        FirebaseService.SetPompaPengisian();
                      } else if (widget.buttonName.contains('SPRAYER')) {
                        FirebaseService.SetSprayer();
                      }
                    },
                  );
                },
              ),
            );
          },
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          widget.buttonName,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
