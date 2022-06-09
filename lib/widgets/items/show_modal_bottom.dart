import 'package:flutter/material.dart';
import 'package:greenhouse/services/ServiceFirebase.dart';
import 'package:greenhouse/widgets/title/title_ph.dart';

class InputDialog {
  static void showModalInput(BuildContext context, String type) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    final _controllerValue = TextEditingController();
    late String label;

    if (type == "set_ppm") {
      try {
        label = 'Target PPM';
      } catch (e) {
        print(e);
      }
    }
    if (type == "set_humidity") {
      label = 'Atur Humidity';
    }
    if (type == "set_ph") {
      label = 'Target PH';
    }
    if (type == "set_moisture_on") {
      label = 'batas bawah -> irigasi hidup';
    }
    if (type == "set_moisture_off") {
      label = 'batas atas -> irigasi mati';
    }
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      barrierColor: Colors.transparent,
      backgroundColor: Colors.grey,
      elevation: 10,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: SingleChildScrollView(
            key: _scaffoldKey,
            child: Column(
              children: [
                Center(
                  child: TextFormField(
                    controller: _controllerValue,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      isDense: true,
                      label: Text(
                        'Atur $label',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () async {
                          print(_controllerValue.text);
                          validateVal(type, _controllerValue.text, context);
                          Navigator.of(context).pop();
                        },
                        child: const Text('Ok'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Kembali'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static void validateVal(String type, String value, BuildContext context) {
    isValidate = false;
    print('validate $type');
    if (value.isEmpty) return;
    try {
      if (type == 'set_interval_on_ph') {
        FirebaseService.SetIntervalOnPh(value);
      }
    } catch (e) {
      print(e);
    }
    try {
      if (type == 'set_interval_off_ph') {
        FirebaseService.SetIntervalOffPh(value);
      }
    } catch (e) {
      print(e);
    }
    try {
      if (type == 'set_interval_off_ppm') {
        FirebaseService.SetIntervalOffPpm(value);
      }
    } catch (e) {
      print(e);
    }
    try {
      if (type == 'set_interval_on_ppm') {
        FirebaseService.SetIntervalOnPpm(value);
      }
    } catch (e) {
      print(e);
    }
    try {
      if (type == 'set_ppm') {
        FirebaseService.SetPpm(value);
      }
    } catch (e) {
      print(e);
    }
    try {
      if (type == 'set_ph') {
        FirebaseService.SetPh(value);
      }
    } catch (e) {
      print(e);
    }

    try {
      if (value.isEmpty) return;
      if (type == 'set_moisture_off') {
        FirebaseService.SetMoistureOff(value);
      }
    } catch (e) {
      print(e);
    }
    try {
      if (value.isEmpty) return;
      if (type == 'set_moisture_on') {
        FirebaseService.SetMoistureOn(value);
      }
    } catch (e) {
      print(e);
    }
    try {
      if (value.isEmpty) return;
      if (type == 'set_mode_ph') {
        FirebaseService.ModePh(value);
      }
    } catch (e) {
      print(e);
    }
    try {
      if (value.isEmpty) return;
      if (type == 'set_mode_ppm') {
        FirebaseService.ModePPm(value);
      }
    } catch (e) {
      print(e);
    }
    try {
      if (value.isEmpty) return;
      if (type == 'set_mode_irigasi') {
        FirebaseService.ModeIrigasi(value);
      }
    } catch (e) {
      print(e);
    }
  }
}
