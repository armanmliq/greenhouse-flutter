import 'package:firebase_database/firebase_database.dart';
import 'package:greenhouse/constant/constant.dart' as constant;
import 'package:greenhouse/services/connectivity.dart';

initializeAccount() async {
  bool isInternetConnected = false;

  CheckInternet().then((value) {
    print('================= CALLING INITIALIZE >====================');
    print('>>>INTERNET $value');
    isInternetConnected = value;

    if (isInternetConnected) {
      InitSensorStatus();
      try {} catch (er) {
        print('ersensor_status $er');
      }
      try {
        InitScheduler();
      } catch (er) {
        print('InitScheduler $er');
      }
      try {
        InitSetParameter();
      } catch (er) {
        print('ersetParameter $er');
      }

      try {
        InitGrafik().InitGrafikPH();
      } catch (er) {
        print('erPH $er');
      }
      try {
        InitGrafik().InitGrafikPpm();
      } catch (er) {
        print('erPPM $er');
      }
      try {
        InitGrafik().InitGrafikTemperature();
      } catch (er) {
        print('erTEMPERATURE $er');
      }
      try {
        InitGrafik().InitGrafikHumidity();
      } catch (er) {
        print('erHUMIDITY $er');
      }
    } else {
      print('failed.initialize... \ninternet not connected');
    }
    print('================= END OF CALLING INITIALIZE ====================');
  });
}

Future InitSensorStatus() async {
  final sensor = FirebaseDatabase.instance
      .ref()
      .child('users')
      .child(constant.uid)
      .child('sensor_status');
  return await sensor.get().then(
        (DocumentSnapshot) => {
          if (!DocumentSnapshot.exists)
            {
              // ignore: avoid_print
              print('initialize sensor_status not exist, CREATE ONE'),
              sensor.set({
                'humidity': "50",
                'ph': "6.0",
                'ppm': "1000",
                'tankLevel': "50",
                'temperature': "20.0",
                'sprayer_status': "MATI",
                'pompa_status': "MATI",
                'pompa_nutrisi_status': "MATI",
              }),
            }
          else
            {
              print('initialize sensor_status data EXIST'),
            }
        },
      );
}

Future InitSetParameter() async {
  final setParameter = FirebaseDatabase.instance
      .ref()
      .child('users')
      .child(constant.uid)
      .child("set_parameter");
  return await setParameter.get().then(
        // ignore: non_constant_identifier_names
        (DocumentSnapshot) => {
          if (!DocumentSnapshot.exists)
            {
              print('initialize set_parameter not exist, CREATE ONE'),
              setParameter.set({
                'set_humidity': '20',
                'set_ppm': '1000',
                'set_ph': '6',
                'set_moisture_off': '90',
                'set_moisture_on': '60',
                'set_mode_ph': 'manual',
                'set_mode_ppm': 'manual',
                'set_mode_irigasi': 'manual',
              }),
            }
          else
            {
              print('initialize set_parameter data EXIST'),
            }
        },
      );
}

Future InitScheduler() async {
  final scheduler = FirebaseDatabase.instance
      .ref()
      .child('users')
      .child(constant.uid)
      .child("scheduler");
  return await scheduler.get().then(
        // ignore: non_constant_identifier_names
        (DocumentSnapshot) => {
          if (!DocumentSnapshot.exists)
            {
              print('initialize set_parameter not exist, CREATE ONE'),
              scheduler.set({
                'scheduler_ppm': '20',
                'scheduler_irigasi': '1000',
              }),
            }
          else
            {
              print('initialize set_parameter data EXIST'),
            }
        },
      );
}

class InitGrafik {
  Future InitGrafikPpm() async {
    final PPM = FirebaseDatabase.instance
        .ref()
        .child('users')
        .child(constant.uid)
        .child("grafik")
        .child('PPM');
    return await PPM.get().then(
          // ignore: non_constant_identifier_names
          (DocumentSnapshot) => {
            if (!DocumentSnapshot.exists)
              {
                print('initialize PPM not exist, CREATE ONE'),
                PPM.set({
                  "1652776630": "237",
                  "1652777530": "274",
                  "1652778430": "389",
                  "1652779330": "348",
                  "1652780230": "262",
                  "1652781130": "350",
                  "1652782030": "273",
                  "1652782930": "255",
                  "1652783830": "253",
                  "1652784730": "395",
                }),
              }
            else
              {
                print('initialize PH data EXIST'),
              }
          },
        );
  }

  Future InitGrafikPH() async {
    final PH = FirebaseDatabase.instance
        .ref()
        .child('users')
        .child(constant.uid)
        .child("grafik")
        .child('PH');
    return await PH.get().then(
          // ignore: non_constant_identifier_names
          (DocumentSnapshot) => {
            if (!DocumentSnapshot.exists)
              {
                print('initialize PH not exist, CREATE ONE'),
                PH.set({
                  "1652776630": "237",
                  "1652777530": "274",
                  "1652778430": "389",
                  "1652779330": "348",
                  "1652780230": "262",
                  "1652781130": "350",
                  "1652782030": "273",
                  "1652782930": "255",
                  "1652783830": "253",
                }),
              }
            else
              {
                print('initialize PH data EXIST'),
              }
          },
        );
  }

  Future InitGrafikHumidity() async {
    final TEMPERATURE = FirebaseDatabase.instance
        .ref()
        .child('users')
        .child(constant.uid)
        .child("grafik")
        .child('TEMPERATURE');
    return await TEMPERATURE.get().then(
          // ignore: non_constant_identifier_names
          (DocumentSnapshot) => {
            if (!DocumentSnapshot.exists)
              {
                print('initialize TEMPERATURE not exist, CREATE ONE'),
                TEMPERATURE.set({
                  "1652790028": "5.1",
                  "1652790088": "4.8",
                  "1652790148": "4.7",
                  "1652790208": "5.3",
                  "1652790268": "4.5",
                  "1652790328": "5.7",
                  "1652790388": "5.3",
                  "1652790448": "4.2",
                  "1652790508": "5.4",
                }),
              }
            else
              {
                print('initialize TEMPERATURE data EXIST'),
              }
          },
        );
  }

  Future InitGrafikTemperature() async {
    final TEMPERATURE = FirebaseDatabase.instance
        .ref()
        .child('users')
        .child(constant.uid)
        .child("grafik")
        .child('TEMPERATURE');
    return await TEMPERATURE.get().then(
          // ignore: non_constant_identifier_names
          (DocumentSnapshot) => {
            if (!DocumentSnapshot.exists)
              {
                print('initialize TEMPERATURE not exist, CREATE ONE'),
                TEMPERATURE.set({
                  "1652790028": "5.1",
                  "1652790088": "4.8",
                  "1652790148": "4.7",
                  "1652790208": "5.3",
                  "1652790268": "4.5",
                  "1652790328": "5.7",
                  "1652790388": "5.3",
                  "1652790448": "4.2",
                  "1652790508": "5.4",
                  "1652790568": "5.1",
                  "1652790628": "20"
                }),
              }
            else
              {
                print('initialize TEMPERATURE data EXIST'),
              }
          },
        );
  }
}
