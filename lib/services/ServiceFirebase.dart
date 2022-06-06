import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:greenhouse/constant/constant.dart' as constant;
import 'package:greenhouse/services/connectivity.dart';
import 'package:greenhouse/widgets/title/title_control_penyiraman.dart';

class FirebaseService {
  double? maxMoistureOn;
  double? maxMoistureOff;

  static final dataRef = FirebaseDatabase.instance
      .ref()
      .child('users')
      .child(constant.uid)
      .child('set_parameter');

  static Future<void> OnOffIrigasi(String state) async {
    //cek koneksi dahulu
    CheckInternet().then((stateInternet) {
      if (!stateInternet) {
        BotToast.showText(text: 'tidak ada koneksi internet');
        return;
      }
    });
    await dataRef.update({
      'set_irigasi_pump': state.toString(),
    }).then((value) {
      BotToast.showText(text: 'POMPA IRIGASI $state');
    }).catchError((er) {
      BotToast.showText(text: 'GAGAL');
    });
  }

  static Future<void> OnOffSprayer(String state) async {
    //cek koneksi dahulu
    CheckInternet().then((stateInternet) {
      if (!stateInternet) {
        BotToast.showText(text: 'tidak ada koneksi internet');
        return;
      }
    });
    await dataRef.update({
      'set_sprayer_pump': state.toString(),
    }).then((value) {
      BotToast.showText(text: 'POMPA sprayer $state');
    }).catchError((er) {
      BotToast.showText(text: 'GAGAL');
    });
  }

  static Future<void> OnOffPhUp(String state) async {
    //cek koneksi dahulu
    CheckInternet().then((stateInternet) {
      if (!stateInternet) {
        BotToast.showText(text: 'tidak ada koneksi internet');
        return;
      }
    });
    await dataRef.update({
      'set_dosing_pump_ph_up': state.toString(),
    }).then((value) {
      BotToast.showText(text: 'POMPA PH UP  $state');
    }).catchError((er) {
      BotToast.showText(text: 'GAGAL');
    });
  }

  static Future<void> OnOffPhDown(String state) async {
    //cek koneksi dahulu
    CheckInternet().then((stateInternet) {
      if (!stateInternet) {
        BotToast.showText(text: 'tidak ada koneksi internet');
        return;
      }
    });
    await dataRef.update({
      'set_dosing_pump_ph_down': state.toString(),
    }).then((value) {
      BotToast.showText(text: 'POMPA PH DOWN  $state');
    }).catchError((er) {
      BotToast.showText(text: 'GAGAL');
    });
  }

  static Future<void> OnOffPpm(String state) async {
    //cek koneksi dahulu
    CheckInternet().then((stateInternet) {
      if (!stateInternet) {
        BotToast.showText(text: 'tidak ada koneksi internet');
        return;
      }
    });
    await dataRef.update({
      'set_dosing_pump_ppm': state.toString(),
    }).then((value) {
      BotToast.showText(text: 'POMPA PPM UP  $state');
    }).catchError((er) {
      BotToast.showText(text: 'GAGAL');
    });
  }

  static Future<void> ModePPm(String mode) async {
    //cek koneksi dahulu
    CheckInternet().then((stateInternet) {
      if (!stateInternet) {
        BotToast.showText(text: 'tidak ada koneksi internet');
        return;
      }
    });
    late String modeSrc;
    mode == 'manual' ? modeSrc = 'otomatis' : modeSrc = 'manual';
    await dataRef.update({
      'set_mode_ppm': modeSrc.toString(),
    }).then((value) {
      BotToast.showText(text: 'Mode PPM $modeSrc');
    }).catchError((er) {
      BotToast.showText(text: 'GAGAL');
    });
  }

  static Future<void> ModePh(String mode) async {
    //cek koneksi dahulu
    CheckInternet().then((stateInternet) {
      if (!stateInternet) {
        BotToast.showText(text: 'tidak ada koneksi internet');
        return;
      }
    });
    late String modeSrc;
    mode == 'manual' ? modeSrc = 'otomatis' : modeSrc = 'manual';
    await dataRef.update({
      'set_mode_ph': modeSrc.toString(),
    }).then((value) {
      BotToast.showText(text: 'Mode PH $modeSrc');
    }).catchError((er) {
      BotToast.showText(text: 'GAGAL');
    });
  }

  static Future<void> ModeIrigasi(String modeStr) async {
    //cek koneksi dahulu
    CheckInternet().then((stateInternet) {
      if (!stateInternet) {
        BotToast.showText(text: 'tidak ada koneksi internet');
        return;
      }
    });
    late String mode;
    modeStr == 'manual' ? mode = 'otomatis' : mode = 'manual';
    print(modeStr);
    await dataRef.update({
      'set_mode_irigasi': mode.toString(),
    }).then((value) {
      BotToast.showText(text: 'Mode IRIGASI $modeStr');
    }).catchError((er) {
      BotToast.showText(text: 'GAGAL');
    });
  }

  static Future<void> SetMoistureOn(String values) async {
    //cek koneksi dahulu
    CheckInternet().then((stateInternet) {
      if (!stateInternet) {
        BotToast.showText(text: 'tidak ada koneksi internet');
        return;
      }
    });
    int maxMoisture = 100;
    double val = double.parse(values);
    bool moistureOnInRange = (val <= maxMoisture && val > 0) ? true : false;
    if (moistureOnInRange) {
      await dataRef.update({
        'set_moisture_on': val.ceil().toString(),
      }).then((value) {
        BotToast.showText(text: 'irigasi hidup pada moisture $values');
      }).catchError((er) {
        BotToast.showText(text: 'GAGAL');
      });
    } else {
      BotToast.showText(text: 'set value dibawah $maxMoisture');
    }
  }

  static Future<void> SetMoistureOff(String values) async {
    //cek koneksi dahulu
    CheckInternet().then((stateInternet) {
      if (!stateInternet) {
        BotToast.showText(text: 'tidak ada koneksi internet');
        return;
      }
    });
    int maxMoisture = 100;
    double val = double.parse(values);
    bool moistureOffInRange = (val <= maxMoisture && val > 0) ? true : false;
    if (moistureOffInRange) {
      await dataRef.update({
        'set_moisture_off': val.ceil().toString(),
      }).then((value) {
        BotToast.showText(text: 'irigasi mati pada moisture $values');
      }).catchError((er) {
        BotToast.showText(text: 'GAGAL');
      });
    } else {
      BotToast.showText(text: 'set value dibawah $maxMoisture');
    }
  }

  static Future<void> SetPh(String values) async {
    //cek koneksi dahulu
    CheckInternet().then((stateInternet) {
      if (!stateInternet) {
        BotToast.showText(text: 'tidak ada koneksi internet');
        return;
      }
    });
    int maxPh = 12;
    double val = double.parse(values);
    bool phInRange = (val <= maxPh && val > 0) ? true : false;
    if (!phInRange) {
      BotToast.showText(text: 'setting ph harus dibawah $maxPh');
      return;
    }

    try {
      dataRef.update({'set_ph': val.toString()}).then((_) {
        BotToast.showText(text: 'setting ph to $val');
      });
    } catch (e) {
      print('update ph error $e');
    }
  }

  static Future<void> SetPpm(String values) async {
    //cek koneksi dahulu
    CheckInternet().then((stateInternet) {
      if (!stateInternet) {
        BotToast.showText(text: 'tidak ada koneksi internet');
        return;
      }
    });
    int maxPpm = 1300;
    double val = double.parse(values);
    bool ppmInRange = (val <= maxPpm && val > 0) ? true : false;
    if (!ppmInRange) {
      BotToast.showText(text: 'setting ppm harus dibawah $maxPpm');
      return;
    }

    try {
      dataRef.update({'set_ppm': val.ceil().toString()}).then((_) {
        BotToast.showText(text: 'setting ppm to $values');
      });
    } catch (e) {
      print('update ppm $e');
    }
  }

  static Future<void> SetPompaPenyiraman(bool state) async {
    //cek koneksi dahulu
    CheckInternet().then((stateInternet) {
      if (!stateInternet) {
        BotToast.showText(text: 'tidak ada koneksi internet');
        return;
      }
    });
    String status = state ? 'HIDUP' : 'MATI';
    print('isReturn');
    try {
      dataRef.update({'set_pompa_penyiraman': status.toString()}).then((_) {
        state == true
            ? BotToast.showText(text: 'penyiraman dihidupkan')
            : BotToast.showText(text: 'penyiraman dimatikan');
      });
    } catch (e) {
      print('error SetPompaPenyiraman $e');
    }
  }

  static Future<void> getStatusPompaPenyiraman() async {
    final pompaPenyiramanRef = FirebaseDatabase.instance
        .ref()
        .child('users')
        .child(constant.uid)
        .child("set_parameter")
        .child("set_pompa_penyiraman")
        .get();

    //cek koneksi dahulu
    CheckInternet().then((stateInternet) {
      if (!stateInternet) {
        // BotToast.showText(text: 'tidak ada koneksi internet');
        return;
      }
    });
    print('statePenyiraman ');
    pompaPenyiramanRef.then((value) {
      print('statePenyiraman ${value.value}');
      value.value == 'HIDUP'
          ? constant.stateButtonPenyiramaan = true
          : constant.stateButtonPenyiramaan = false;
    });
  }
}
