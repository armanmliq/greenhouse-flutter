import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:greenhouse/constant/constant.dart' as constant;

import 'package:greenhouse/services/connectivity.dart';
import 'package:greenhouse/services/shared_pref.dart';

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
    mode == 'MANUAL' ? modeSrc = 'OTOMATIS' : modeSrc = 'MANUAL';
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
    mode == 'MANUAL' ? modeSrc = 'OTOMATIS' : modeSrc = 'MANUAL';
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
    modeStr == 'MANUAK' ? mode = 'OTOMATIS' : mode = 'MANUAL';
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
    double val = double.parse(values);
    bool ppmInRange = (val <= constant.maxPpm && val > 0) ? true : false;
    if (!ppmInRange) {
      BotToast.showText(text: 'setting ppm harus dibawah ${constant.maxPpm}');
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

  static Future<void> SetIntervalOnPpm(String values) async {
    //cek koneksi dahulu
    CheckInternet().then((stateInternet) {
      if (!stateInternet) {
        BotToast.showText(text: 'tidak ada koneksi internet');
        return;
      }
    });
    double val = double.parse(values);
    bool intervalOnPPmInRange =
        (val <= (constant.maxIntervalOnPpm / 1000) && val > 0) ? true : false;
    if (!intervalOnPPmInRange) {
      BotToast.showText(
          text:
              'setting interval on harus dibawah ${(constant.maxIntervalOnPpm / 1000).toStringAsFixed(0)} detik');
      return;
    }
    val *= 1000;
    try {
      dataRef.update({'set_interval_on_ppm': val.ceil().toString()}).then((_) {
        BotToast.showText(text: 'setting interval on to $values');
      });
    } catch (e) {
      print('update interval on $e');
    }
  }

  static Future<void> SetIntervalOffPh(String values) async {
    //cek koneksi dahulu
    CheckInternet().then((stateInternet) {
      if (!stateInternet) {
        BotToast.showText(text: 'tidak ada koneksi internet');
        return;
      }
    });
    double val = double.parse(values);
    bool intervalOffPhInRange =
        (val <= (constant.maxIntervalOffPh / 1000) && val > 0) ? true : false;
    if (!intervalOffPhInRange) {
      BotToast.showText(
          text:
              'setting interval off harus dibawah ${(constant.maxIntervalOffPh / 1000).toStringAsFixed(0)} detik');
      return;
    }
    val *= 1000;
    try {
      dataRef.update({'set_interval_off_ph': val.ceil().toString()}).then((_) {
        BotToast.showText(text: 'setting interval off to $values');
      });
    } catch (e) {
      print('update interval off $e');
    }
  }

  static Future<void> SetIntervalOnPh(String values) async {
    //cek koneksi dahulu
    CheckInternet().then((stateInternet) {
      if (!stateInternet) {
        BotToast.showText(text: 'tidak ada koneksi internet');
        return;
      }
    });
    double val = double.parse(values);
    bool intervalOnPhInRange =
        (val <= (constant.maxIntervalOnPh / 1000) && val > 0) ? true : false;
    if (!intervalOnPhInRange) {
      BotToast.showText(
          text:
              'setting interval on harus dibawah ${(constant.maxIntervalOnPh / 1000).toStringAsFixed(0)} detik');
      return;
    }
    val *= 1000;
    try {
      dataRef.update({'set_interval_on_ph': val.ceil().toString()}).then((_) {
        BotToast.showText(text: 'setting interval on to $values');
      });
    } catch (e) {
      print('update interval on $e');
    }
  }

  static Future<void> SetIntervalOffPpm(String values) async {
    //cek koneksi dahulu
    CheckInternet().then((stateInternet) {
      if (!stateInternet) {
        BotToast.showText(text: 'tidak ada koneksi internet');
        return;
      }
    });
    double val = double.parse(values);
    bool intervalOffPPmInRange =
        (val <= (constant.maxIntervalOffPpm / 1000) && val > 0) ? true : false;
    if (!intervalOffPPmInRange) {
      BotToast.showText(
          text:
              'setting interval off harus dibawah ${(constant.maxIntervalOffPpm / 1000).toStringAsFixed(0)} detik');
      return;
    }
    val *= 1000;
    try {
      dataRef.update({'set_interval_off_ppm': val.ceil().toString()}).then((_) {
        BotToast.showText(text: 'setting interval off to $values');
      });
    } catch (e) {
      print('update interval off $e');
    }
  }

  static Future<void> SetPompaPenyiraman() async {
    //cek koneksi dahulu
    CheckInternet().then((stateInternet) {
      if (!stateInternet) {
        BotToast.showText(text: 'tidak ada koneksi internet');
        return;
      }
    });
    constant.stateButtonPenyiramaan = !constant.stateButtonPenyiramaan;
    String status = constant.stateButtonPenyiramaan ? 'HIDUP' : 'MATI';

    print('isReturn');
    try {
      dataRef.update({'set_pompa_penyiraman': status.toString()}).then((_) {
        status == 'HIDUP'
            ? BotToast.showText(text: 'pompa penyiraman dihidupkan')
            : BotToast.showText(text: 'pompa penyiraman dimatikan');
      });
    } catch (e) {
      print('error SetPompaPenyiraman $e');
    }
  }

  static Future<void> SetPompaPengisian() async {
    //cek koneksi dahulu
    CheckInternet().then((stateInternet) {
      if (!stateInternet) {
        BotToast.showText(text: 'tidak ada koneksi internet');
        return;
      }
    });
    constant.stateButtonPengisian = !constant.stateButtonPengisian;
    String status = constant.stateButtonPengisian ? 'HIDUP' : 'MATI';
    print('isReturn');
    try {
      dataRef.update({'set_pompa_pengisian': status.toString()}).then((_) {
        status == 'HIDUP'
            ? BotToast.showText(text: 'pompa pengisian dihidupkan')
            : BotToast.showText(text: 'pompa pengisian dimatikan');
      });
    } catch (e) {
      print('error SetPompaPenyiraman $e');
    }
  }

  static Future<void> SetPompaPhUp() async {
    //cek koneksi dahulu
    CheckInternet().then((stateInternet) {
      if (!stateInternet) {
        BotToast.showText(text: 'tidak ada koneksi internet');
        return;
      }
    });
    InternalPreferences().prefsRead('set_mode_ph').then((_value) {
      if (_value == 'OTOMATIS') {
        BotToast.showText(text: 'dapat digunakan pada saat mode ph manual');
        return;
      } else {
        constant.stateButtonPhUp = !constant.stateButtonPhUp;
        String status = constant.stateButtonPhUp ? 'HIDUP' : 'MATI';
        try {
          dataRef.update({'set_pompa_ph_up': status.toString()}).then((_) {
            status == 'HIDUP'
                ? BotToast.showText(text: 'pompa ph up dihidupkan')
                : BotToast.showText(text: 'pompa ph up dimatikan');
          });
        } catch (e) {
          print('error SetPompa ph up $e');
        }
      }
    });
  }

  static Future<void> SetPompaPhDown() async {
    //cek koneksi dahulu
    CheckInternet().then((stateInternet) {
      if (!stateInternet) {
        BotToast.showText(text: 'tidak ada koneksi internet');
        return;
      }
    });

    InternalPreferences().prefsRead('set_mode_ph').then((_value) {
      if (_value == 'OTOMATIS') {
        BotToast.showText(text: 'dapat digunakan pada saat mode ph manual');
        return;
      } else {
        constant.stateButtonPhDown = !constant.stateButtonPhDown;
        String status = constant.stateButtonPhDown ? 'HIDUP' : 'MATI';
        print('isReturn');
        try {
          dataRef.update({'set_pompa_ph_down': status.toString()}).then((_) {
            status == 'HIDUP'
                ? BotToast.showText(text: 'pompa ph down dihidupkan')
                : BotToast.showText(text: 'pompa ph down dimatikan');
          });
        } catch (e) {
          print('error SetPompa ph down $e');
        }
      }
    });
  }

  static Future<void> SetPompaPpmUp() async {
    //cek koneksi dahulu
    CheckInternet().then((stateInternet) {
      if (!stateInternet) {
        BotToast.showText(text: 'tidak ada koneksi internet');
        return;
      }
    });
    InternalPreferences().prefsRead('set_mode_ppm').then((_value) {
      print('[getStatusModePpm] $_value');
      if (_value == 'OTOMATIS') {
        BotToast.showText(text: 'dapat digunakan pada saat ppm mode manual');
        return;
      } else {
        constant.stateButtonPpmUp = !constant.stateButtonPpmUp;
        String status = constant.stateButtonPpmUp ? 'HIDUP' : 'MATI';
        print('isReturn');
        try {
          dataRef.update({'set_pompa_ppm_up': status.toString()}).then((_) {
            status == 'HIDUP'
                ? BotToast.showText(text: 'pompa ppm up dihidupkan')
                : BotToast.showText(text: 'pompa ppm up dimatikan');
          });
        } catch (e) {
          print('error SetPompa ppm up $e');
        }
      }
    });
  }

  static Future<void> getStatusPompaPengisian() async {
    final pompaPengisianRef = FirebaseDatabase.instance
        .ref()
        .child('users')
        .child(constant.uid)
        .child("sensor_status")
        .child("pompa_status")
        .get();

    //cek koneksi dahulu
    CheckInternet().then((stateInternet) {
      if (!stateInternet) {
        // BotToast.showText(text: 'tidak ada koneksi internet');
        return;
      }
    });

    print('statePengisian ');
    pompaPengisianRef.then((value) {
      print('statePengisian ${value.value}');
      value.value == 'HIDUP'
          ? constant.stateButtonPengisian = true
          : constant.stateButtonPengisian = false;
    });
  }

  static Future<void> getStatusPompaPhUp() async {
    final pompaPhUp = FirebaseDatabase.instance
        .ref()
        .child('users')
        .child(constant.uid)
        .child("sensor_status")
        .child("pompaPhUpStatus")
        .get();

    //cek koneksi dahulu
    CheckInternet().then((stateInternet) {
      if (!stateInternet) {
        // BotToast.showText(text: 'tidak ada koneksi internet');
        return;
      }
    });
    print('statePhUp ');
    pompaPhUp.then((value) {
      print('statePhUp ${value.value}');
      value.value == 'HIDUP'
          ? constant.stateButtonPhUp = true
          : constant.stateButtonPhUp = false;
    });
  }

  static Future<void> getStatusPompaPhDown() async {
    final pompaPhDown = FirebaseDatabase.instance
        .ref()
        .child('users')
        .child(constant.uid)
        .child("sensor_status")
        .child("pompaPhDownStatus")
        .get();

    //cek koneksi dahulu
    CheckInternet().then((stateInternet) {
      if (!stateInternet) {
        // BotToast.showText(text: 'tidak ada koneksi internet');
        return;
      }
    });
    print('statePhUp ');
    pompaPhDown.then((value) {
      print('statePhDown ${value.value}');
      value.value == 'HIDUP'
          ? constant.stateButtonPhDown = true
          : constant.stateButtonPhDown = false;
    });
  }

  static Future<void> getStatusPompaPpmUp() async {
    final pompaPhDown = FirebaseDatabase.instance
        .ref()
        .child('users')
        .child(constant.uid)
        .child("sensor_status")
        .child("pompa_nutrisi_status")
        .get();

    //cek koneksi dahulu
    CheckInternet().then((stateInternet) {
      if (!stateInternet) {
        // BotToast.showText(text: 'tidak ada koneksi internet');
        return;
      }
    });
    print('statePpmUp ');
    pompaPhDown.then((value) {
      print('statePpmUp ${value.value}');
      value.value == 'HIDUP'
          ? constant.stateButtonPpmUp = true
          : constant.stateButtonPpmUp = false;
    });
  }

  static Future<void> getStatusPompaPenyiraman() async {
    final pompaPenyiramanRef = FirebaseDatabase.instance
        .ref()
        .child('users')
        .child(constant.uid)
        .child("sensor_status")
        .child("pompaPenyiraman")
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

  // static Future<String?> getStatusModePpm() async {}
}
