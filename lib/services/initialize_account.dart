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
        InitSetParameter();
      } catch (er) {
        print('ersetParameter $er');
      }

      try {
        InitGrafik().InitGrafikPh();
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
      try {
        InitGrafik().InitGrafikWaterTemp();
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
              print('initialize sensor_status not exist, CREATE ONE'),
              sensor.set({
                'humidity': "50",
                'ph': "6.0",
                'ppm': "1000",
                'tankLevel': "50",
                'temperature': "20.0",
                'temperatureWater': "20.0",
                'sprayer_status': "MATI",
                'pompa_status': "MATI",
                'pompa_nutrisi_status': "MATI",
                'pompaPhUpStatus': "MATI",
                'pompaPhDownStatus': "MATI",
                'pompaPenyiraman': "MATI",
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
                'set_pompa_penyiraman': 'manual',
                'scheduler_ppm_str': '[]',
                'scheduler_irigasi': '[]',
                'waterTemp': "50",
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
        .child('ph');
    return await PPM.get().then(
          // ignore: non_constant_identifier_names
          (DocumentSnapshot) => {
            if (!DocumentSnapshot.exists)
              {
                print('initialize PPM not exist, CREATE ONE'),
                PPM.set({
                  "1652776630": "237",
                }),
              }
            else
              {
                print('initialize PH data EXIST'),
              }
          },
        );
  }

  Future InitGrafikPh() async {
    final _ph = FirebaseDatabase.instance
        .ref()
        .child('users')
        .child(constant.uid)
        .child("grafik")
        .child('ph');
    return await _ph.get().then(
          // ignore: non_constant_identifier_names
          (DocumentSnapshot) => {
            if (!DocumentSnapshot.exists)
              {
                print('initialize humidity not exist, CREATE ONE'),
                _ph.set({
                  "1652790028": "5.1",
                }),
              }
            else
              {
                print('initialize TEMPERATURE data EXIST'),
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
        .child('humidity');
    return await TEMPERATURE.get().then(
          // ignore: non_constant_identifier_names
          (DocumentSnapshot) => {
            if (!DocumentSnapshot.exists)
              {
                print('initialize humidity not exist, CREATE ONE'),
                TEMPERATURE.set({
                  "1652790028": "5.1",
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
        .child('temp');
    return await TEMPERATURE.get().then(
          // ignore: non_constant_identifier_names
          (DocumentSnapshot) => {
            if (!DocumentSnapshot.exists)
              {
                print('initialize TEMPERATURE not exist, CREATE ONE'),
                TEMPERATURE.set({
                  "1652790028": "5.1",
                }),
              }
            else
              {
                print('initialize TEMPERATURE data EXIST'),
              }
          },
        );
  }

  Future InitGrafikWaterTemp() async {
    final waterTemp = FirebaseDatabase.instance
        .ref()
        .child('users')
        .child(constant.uid)
        .child("grafik")
        .child('waterTemp');
    return await waterTemp.get().then(
          // ignore: non_constant_identifier_names
          (DocumentSnapshot) => {
            if (!DocumentSnapshot.exists)
              {
                print('initialize waterTemp not exist, CREATE ONE'),
                waterTemp.set({
                  "1652790028": "5.1",
                }),
              }
            else
              {
                print('initialize v data EXIST'),
              }
          },
        );
  }
}
