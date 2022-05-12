import 'package:flutter/widgets.dart';

class Sensor with ChangeNotifier {
  String? temperature;
  String? humidity;
  String? tankLevel;
  String? ppm;
  String? ph;
  String? setHumidity;
  String? setPpm;
  String? sprayer_status;
  String? pompa_nutrisi_status;
  String? pompa_status;

  Sensor();

  Sensor.fromSnapshotSensorStatus(snapshot) {
    try {
      if (snapshot.hasData) {
        print('================[GET SensorStatus]=====================');
        print(
            'temperature ==========${snapshot.data['temperature']} ${snapshot.data['temperature'].runtimeType}');
        print(
            'humidity    ==========${snapshot.data['humidity']} ${snapshot.data['humidity'].runtimeType}');
        print(
            'tankLevel   ==========${snapshot.data['tankLevel']} ${snapshot.data['tankLevel'].runtimeType}');
        print(
            'ppm         ==========${snapshot.data['ppm']} ${snapshot.data['ppm'].runtimeType}');
        print(
            'ph          ==========${snapshot.data['ph']} ${snapshot.data['ph'].runtimeType}');
        print('================[GET SensorStatus]=====================');
        print('================[PARSING SensorStatus]=====================');
        try {
          temperature = snapshot.data['temperature'];
        } catch (e) {
          print('Error parsing temp');
        }
        try {
          humidity = snapshot.data['humidity'];
        } catch (e) {
          print('Error parsing humid');
        }
        try {
          tankLevel = snapshot.data['tankLevel'];
        } catch (e) {
          print('Error parsing tank');
        }
        try {
          ppm = snapshot.data['ppm'];
        } catch (e) {
          print('Error parsing ppm');
        }
        try {
          ph = snapshot.data['ph'];
        } catch (e) {
          print('Error parsing ph');
        }
        print('================[PARSING SensorStatus]=====================');
      }
    } catch (err) {
      print('ERROR FROM fromSnapshotSensorStatus = $err');
    }
  }

  Sensor.fromSnapshotSetParameterStatus(snapshot) {
    try {
      if (snapshot.hasData) {
        print('================[SetParameterStatus]=====================');
        print(
            'set_ppm ==========${snapshot.data['set_ppm']} ${snapshot.data['set_ppm'].runtimeType}');
        print(
            'set_humidity    ==========${snapshot.data['set_humidity']} ${snapshot.data['set_humidity'].runtimeType}');

        print('================[SetParameterStatus]=====================');

        print(
            '================[PARSING SetParameterStatus]=====================');
        try {
          setHumidity = snapshot.data['set_humidity'];
        } catch (e) {
          print('Error parsing set_humidity');
        }
        try {
          setPpm = snapshot.data['set_ppm'];
        } catch (e) {
          print('Error parsing set_ppm');
        }
        print(
            '================[PARSING SetParameterStatus]=====================');
      }
    } catch (err) {
      setPpm = 'no data';
      print('ERROR FROM fromSnapshotSetParameterStatus = $err');
    }
  }
  Sensor.fromSnapshotControlStatus(snapshot) {
    try {
      if (snapshot.hasData) {
        print('================[ControlStatus]=====================');
        print(
            'pompa_nutrisi_status ==========${snapshot.data['pompa_nutrisi_status']} ${snapshot.data['pompa_nutrisi_status'].runtimeType}');
        print(
            'sprayer_status    ==========${snapshot.data['sprayer_status']} ${snapshot.data['sprayer_status'].runtimeType}');

        print(
            'pompa_status    ==========${snapshot.data['pompa_status']} ${snapshot.data['pompa_status'].runtimeType}');

        print('================[ControlStatus]=====================');
        print('================[PARSING ControlStatus]=====================');
        try {
          pompa_nutrisi_status = snapshot.data['pompa_nutrisi_status'];
        } catch (e) {
          print('Error parsing pompa_nutrisi_status');
        }
        try {
          pompa_status = snapshot.data['pompa_status'];
        } catch (e) {
          print('Error parsing pompa_status');
        }
        try {
          sprayer_status = snapshot.data['sprayer_status'];
        } catch (e) {
          print('Error parsing sprayer_status');
        }
        print('================[PARSING ControlStatus]=====================');
      }
    } catch (err) {
      setPpm = 'no data';
      print('ERROR FROM fromSnapshotSetParameterStatus = $err');
    }
  }
}
