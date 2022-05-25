import 'package:flutter/material.dart';
import 'package:greenhouse/widgets/title/title_ph.dart';
import 'package:bot_toast/bot_toast.dart';

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
    const maxPpm = 1300;
    const maxHumidity = 100;
    const maxPh = 14;
    const maxMoisture = 100;
    print('validate $type');
    if (value.isEmpty) return;
    try {
      if (type == 'set_ppm') {
        double val = double.parse(value);
        bool ppmInRange = (val <= maxPpm && val > 0) ? true : false;
        if (!ppmInRange) {
          BotToast.showText(text: 'setting ppm harus dibawah $maxPpm');
          return;
        }
        isValidate = true;

        try {
          databaseRef.update({type: val.ceil().toString()}).then((_) {
            BotToast.showText(text: 'setting ppm to $value');
          });
        } catch (e) {
          print('update ppm $e');
        }
      }
    } catch (e) {
      print(e);
    }
    try {
      if (type == 'set_ph') {
        double val = double.parse(value);
        bool phInRange = (val <= maxPh && val > 0) ? true : false;
        if (!phInRange) {
          BotToast.showText(text: 'setting ph harus dibawah $maxPh');
          return;
        }
        isValidate = true;

        try {
          databaseRef.update({type: val.toString()}).then((_) {
            BotToast.showText(text: 'setting ph to $value');
          });
        } catch (e) {
          print('update ph $e');
        }
      }
    } catch (e) {
      print(e);
    }
    try {
      if (type == 'set_humidity') {
        double val = double.parse(value);
        bool humidityInRange = (val <= maxHumidity && val > 0) ? true : false;

        if (!humidityInRange) {
          print("nilai HUMIDITY harus dibawah $maxHumidity");
          BotToast.showText(
              text: 'setting HUMIDITY harus dibawah $maxHumidity');
          return;
        }
        isValidate = true;
        Navigator.of(context).pop();
        databaseRef.update({
          'set_humidity': val.ceil().toString(),
        });
      }
    } catch (e) {
      print(e);
    }
    try {
      if (value.isEmpty) return;
      double val = double.parse(value);
      bool moistureOffInRange = (val <= 100 && val > 0) ? true : false;
      if (type == 'set_moisture_off') {
        if (!moistureOffInRange) {
          BotToast.showText(
              text: 'setting moisture harus dibawah $maxMoisture');
          return;
        }
        BotToast.showText(text: 'setting moisture to $value');
        isValidate = true;
        databaseRef.update({
          'set_moisture_off': val.ceil().toString(),
        });
      }
    } catch (e) {
      print(e);
    }
    try {
      if (value.isEmpty) return;
      double val = double.parse(value);
      bool moistureOnInRange = (val <= 100 && val > 0) ? true : false;
      if (type == 'set_moisture_on') {
        if (!moistureOnInRange) {
          BotToast.showText(
              text: 'setting moisture harus dibawah $maxMoisture');
          return;
        }
        BotToast.showText(text: 'setting moisture to $value');
        isValidate = true;
        databaseRef.update({
          'set_moisture_on': val.ceil().toString(),
        });
      }
    } catch (e) {
      print(e);
    }
    try {
      if (value.isEmpty) return;
      if (type == 'set_mode_ph') {
        value = value == 'manual' ? 'otomatis' : 'manual';
        databaseRef.update({
          'set_mode_ph': value.toString(),
        });
        BotToast.showText(text: 'setting mode ph to $value');
        isValidate = true;
      }
    } catch (e) {
      print(e);
    }
    try {
      if (value.isEmpty) return;
      if (type == 'set_mode_ppm') {
        value = value == 'manual' ? 'otomatis' : 'manual';
        databaseRef.update({
          'set_mode_ppm': value.toString(),
        });
        BotToast.showText(text: 'setting mode ppm to $value');
        isValidate = true;
      }
    } catch (e) {
      print(e);
    }
    try {
      if (value.isEmpty) return;
      if (type == 'set_mode_irigasi') {
        if (value == 'manual') {
          value = 'otomatis';
        } else if (value == 'otomatis') {
          value = 'jadwal';
        } else if (value == 'jadwal') {
          value = 'manual';
        }

        try {
          databaseRef.update({
            'set_mode_irigasi': value,
          });
        } catch (e) {
          print('er set mode irigasi $e');
        }
        BotToast.showText(
            text: 'setting mode irigasi to ${value.toUpperCase()}');
        isValidate = true;
      }
    } catch (e) {
      print(e);
    }
  }
}
