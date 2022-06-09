import 'dart:collection';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'package:greenhouse/constant/constant.dart';
import 'package:greenhouse/models/jadwal_penyiraman.dart';
import 'package:greenhouse/services/connectivity.dart';
import 'dart:core';
import 'package:greenhouse/services/shared_pref.dart';
import 'package:greenhouse/screens/jadwal_ppm.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:greenhouse/models/model_schedule_json.dart';

DateTime date1 = DateTime.now();
int timestamp1 = date1.millisecondsSinceEpoch;

class Sensor with ChangeNotifier {
  Sensor();
  String? humidity;
  String? tankLevel;
  String? ppm;
  String? ph;
  String? set_humidity;
  String? set_ppm;
  String? set_ph;
  String? sprayer_status;
  String? pompa_nutrisi_status;
  String? pompa_status;
  String? set_moisture_off;
  String? set_moisture_on;
  String? temperature;
  String? temperatureUpdateTime;
  String? humidityUpdateTime;
  String? tankLevelUpdateTime;
  String? ppmUpdateTime;
  String? phUpdateTime;
  String? setHumidityUpdateTime;
  String? setPpmUpdateTime;
  String? setPhUpdateTime;
  String? sprayer_statusUpdateTime;
  String? pompa_nutrisi_statusUpdateTime;
  String? pompa_statusUpdateTime;
  String? set_mode_ppm;
  String? set_mode_ph;
  String? set_mode_irigasi;
  String? scheduler_ppm_str;
  String? scheduler_jadwal_penyiraman;
  String? pompaPhUpStatus;
  String? pompaPhUpStatusUpdateTime;
  String? pompaPhDownStatus;
  String? pompaPhDownStatusUpdateTime;
  String? pompaPenyiraman;
  String? pompaPenyiramanUpdateTime;
  String? temperatureWater;
  String? temperatureWaterUpdateTime;
  String? intervalOnPpm;
  String? intervalOffPpm;
  String? intervalOnPh;
  String? intervalOffPh;
  List<ScheduleItem>? list_scheduler_ppm;
  List<JadwalPenyiraman>? list_scheduler_Jadwal_penyiraman;

  Map<dynamic, dynamic> GrafikPh = {timestamp1.toString(): '0.0'};
  Map<dynamic, dynamic> GrafikTemp = {timestamp1.toString(): '0.0'};
  Map<dynamic, dynamic> GrafikPpm = {timestamp1.toString(): '0.0'};
  Map<dynamic, dynamic> GrafikHumidity = {timestamp1.toString(): '0.0'};
  Map<dynamic, dynamic> GrafikWaterTemp = {timestamp1.toString(): '0.0'};
  Map<dynamic, dynamic> GrafikstatusPompaPenyiraman = {
    timestamp1.toString(): '0.0'
  };

  Future<String> ReadInternalDataOf(String type) async {
    String? value;

    if (type == 'humidity') {
      value = await ReadSensor(type);
    }
    if (type == 'tankLevel') {
      value = await ReadSensor(type);
    }
    if (type == 'ppm') {
      value = await ReadSensor(type);
    }
    if (type == 'ph') {
      value = await ReadSensor(type);
    }
    if (type == 'sprayer_status') {
      value = await ReadSensor(type);
    }
    if (type == 'pompa_status') {
      value = await ReadSensor(type);
    }
    if (type == 'temperature') {
      value = await ReadSensor(type);
    }
    if (type == 'set_moisture_on') {
      value = await ReadSensor(type);
    }
    if (type == 'set_humidity') {
      value = await ReadSensor(type);
    }
    if (type == 'set_ppm') {
      value = await ReadSensor(type);
    }
    if (type == 'set_ph') {
      value = await ReadSensor(type);
    }
    if (type == 'pompa_nutrisi_status') {
      value = await ReadSensor(type);
    }
    if (type == 'set_moisture_off') {
      value = await ReadSensor(type);
    }
    if (type == 'temperatureUpdateTime') {
      value = await ReadSensor(type);
    }
    if (type == 'humidityUpdateTime') {
      value = await ReadSensor(type);
    }
    if (type == 'tankLevelUpdateTime') {
      value = await ReadSensor(type);
    }
    if (type == 'ppmUpdateTime') {
      value = await ReadSensor(type);
    }
    if (type == 'phUpdateTime') {
      value = await ReadSensor(type);
    }
    if (type == 'setHumidityUpdateTime') {
      value = await ReadSensor(type);
    }
    if (type == 'setPpmUpdateTime') {
      value = await ReadSensor(type);
    }
    if (type == 'setPhUpdateTime') {
      value = await ReadSensor(type);
    }
    if (type == 'sprayer_statusUpdateTime') {
      value = await ReadSensor(type);
    }
    if (type == 'pompa_nutrisi_statusUpdateTime') {
      value = await ReadSensor(type);
    }
    if (type == 'pompa_statusUpdateTime') {
      value = await ReadSensor(type);
    }
    if (type == 'set_mode_ph') {
      value = await ReadSensor(type);
    }
    if (type == 'set_mode_ppm') {
      value = await ReadSensor(type);
    }
    if (type == 'set_mode_irigasi') {
      value = await ReadSensor(type);
    }
    if (type == 'scheduler_ppm_str') {
      value = await ReadSensor(type);
    }
    if (type == 'scheduler_jadwal_penyiraman') {
      value = await ReadSensor(type);
    }
    if (type == 'pompaPhUpStatus') {
      value = await ReadSensor(type);
    }
    if (type == 'pompaPhDownStatus') {
      value = await ReadSensor(type);
    }
    if (type == 'pompaPhUpStatusUpdateTime') {
      value = await ReadSensor(type);
    }
    if (type == 'pompaPhDownStatusUpdateTime') {
      value = await ReadSensor(type);
    }
    if (type == 'pompaPenyiramanUpdateTime') {
      value = await ReadSensor(type);
    }
    if (type == 'pompaPenyiraman') {
      value = await ReadSensor(type);
    }
    if (type == 'temperatureWater') {
      value = await ReadSensor(type);
    }
    if (type == 'intervalOnPh') {
      value = await ReadSensor(type);
    }
    if (type == 'intervalOffPh') {
      value = await ReadSensor(type);
    }
    if (type == 'intervalOffPpm') {
      value = await ReadSensor(type);
    }
    if (type == 'intervalOnPpm') {
      value = await ReadSensor(type);
    }
    if (type == 'temperatureWaterUpdateTime') {
      value = await ReadSensor(type);
    }
    return value.toString();
  }

  Future<String?> ReadSensor(String type) async {
    final _prefs = await SharedPreferences.getInstance();
    String? value;
    try {
      if (_prefs.containsKey(type)) {
        value = _prefs.getString(type)!;
        print('reading.$type $value');
      }
    } catch (er) {
      print('error Save.Sensor: $er');
    }
    return value.toString();
  }

  Sensor.fromSnapshotSensorStatus(snap) {
    final _prefs = SharedPreferences.getInstance();
    var data;
    print('====== fromSnapshotSensorStatus ====== ');
    if (snap.hasData) {
      try {
        data = snap.data.snapshot.value;
        try {
          if (data['temperature'] != null) {
            temperature = data['temperature'].toString();
          } else {
            ReadInternalDataOf('temperature').then((value) {
              temperature = value;
            });
          }
          if (data['humidity'] != null) {
            humidity = data['humidity'];
          } else {
            ReadInternalDataOf('humidity').then((value) {
              humidity = value;
            });
          }
          if (data['tankLevel'] != null) {
            tankLevel = data['tankLevel'].toString();
          } else {
            ReadInternalDataOf('tankLevel').then((value) {
              tankLevel = value;
            });
          }
          if (data['ppm'] != null) {
            ppm = data['ppm'].toString();
          } else {
            ReadInternalDataOf('ppm').then((value) {
              ppm = value;
            });
          }
          if (data['ph'] != null) {
            ph = data['ph'].toString();
          } else {
            ReadInternalDataOf('ph').then((value) {
              ph = value;
            });
          }
          if (data['pompa_nutrisi_status'] != null) {
            pompa_nutrisi_status = data['pompa_nutrisi_status'].toString();
          } else {
            ReadInternalDataOf('pompa_nutrisi_status').then((value) {
              pompa_nutrisi_status = value;
            });
          }
          if (data['sprayer_status'] != null) {
            sprayer_status = data['sprayer_status'].toString();
          } else {
            ReadInternalDataOf('sprayer_status').then((value) {
              sprayer_status = value;
            });
          }
          if (data['pompa_status'] != null) {
            pompa_status = data['pompa_status'].toString();
          } else {
            ReadInternalDataOf('pompa_status').then((value) {
              pompa_status = value;
            });
          }
          if (data['pompaPhUpStatus'] != null) {
            pompaPhUpStatus = data['pompaPhUpStatus'].toString();
          } else {
            ReadInternalDataOf('pompaPhUpStatus').then((value) {
              pompaPhUpStatus = value;
            });
          }
          if (data['pompaPhDownStatus'] != null) {
            log(data['pompaPhDownStatus']);
            pompaPhDownStatus = data['pompaPhDownStatus'].toString();
          } else {
            ReadInternalDataOf('pompaPhDownStatus').then((value) {
              pompaPhDownStatus = value;
            });
          }
          if (data['pompaPenyiraman'] != null) {
            log(data['pompaPenyiraman']);
            pompaPenyiraman = data['pompaPenyiraman'].toString();
          } else {
            ReadInternalDataOf('pompaPenyiraman').then((value) {
              pompaPenyiraman = value;
            });
          }
          if (data['temperatureWater'] != null) {
            log(data['temperatureWater']);
            temperatureWater = data['temperatureWater'].toString();
          } else {
            ReadInternalDataOf('temperatureWater').then((value) {
              temperatureWater = value;
            });
          }
        } catch (e) {
          print(e);
        }
      } catch (e) {
        print('snap.data.snapshot.value $e');
      }
    }
    print(' ========== fromSnapshotSensorStatus ====== ');
  }

  void printData(String type, String val) {
    print('=======$type = $val==========');
  }

  Sensor.fromSnapshotSetParameterStatus(snap) {
    try {
      if (snap.hasData) {
        final data = snap.data.snapshot.value;
        print('=======[SetParameterStatus]===========');

        if (data['set_humidity'] != null) {
          set_humidity = data['set_humidity'].toString();
        } else {
          ReadInternalDataOf('set_humidity').then((value) {
            set_humidity = value;
          });
        }
        if (data['set_moisture_off'] != null) {
          set_moisture_off = data['set_moisture_off'].toString();
        } else {
          ReadInternalDataOf('set_moisture_off').then((value) {
            set_moisture_off = value;
          });
        }
        if (data['set_moisture_on'] != null) {
          set_moisture_on = data['set_moisture_on'].toString();
        } else {
          ReadInternalDataOf('set_moisture_on').then((value) {
            set_moisture_on = value;
          });
        }
        if (data['set_ppm'] != null) {
          set_ppm = data['set_ppm'].toString();
        } else {
          ReadInternalDataOf('set_ppm').then((value) {
            set_ppm = value;
          });
        }
        if (data['set_ph'] != null) {
          set_ph = data['set_ph'].toString();
        } else {
          ReadInternalDataOf('set_ph').then((value) {
            set_ph = value;
          });
        }
        if (data['set_mode_ph'] != null) {
          set_mode_ph = data['set_mode_ph'].toString();
        } else {
          ReadInternalDataOf('set_mode_ph').then((value) {
            set_mode_ph = value;
          });
        }

        if (data['set_mode_ppm'] != null) {
          set_mode_ppm = data['set_mode_ppm'].toString();
        } else {
          ReadInternalDataOf('set_mode_ppm').then((value) {
            set_mode_irigasi = value;
          });
        }
        if (data['set_mode_irigasi'] != null) {
          set_mode_irigasi = data['set_mode_irigasi'].toString();
        } else {
          ReadInternalDataOf('set_mode_irigasi').then((value) {
            set_mode_irigasi = value;
          });
        }
        if (data['scheduler_jadwal_penyiraman'] != null) {
          scheduler_jadwal_penyiraman =
              data['scheduler_jadwal_penyiraman'].toString();
        } else {
          ReadInternalDataOf('scheduler_jadwal_penyiraman').then((value) {
            scheduler_jadwal_penyiraman = value;
          });
        }
        if (data['set_interval_on_ph'] != null) {
          print('object');
          intervalOnPh = data['set_interval_on_ph'].toString();
        } else {
          ReadInternalDataOf('set_interval_on_ph').then((value) {
            intervalOnPh = value;
          });
        }
        if (data['set_interval_off_ph'] != null) {
          intervalOffPh = data['set_interval_off_ph'].toString();
        } else {
          ReadInternalDataOf('set_interval_off_ph').then((value) {
            intervalOffPh = value;
          });
        }
        if (data['set_interval_off_ppm'] != null) {
          intervalOffPpm = data['set_interval_off_ppm'].toString();
        } else {
          ReadInternalDataOf('set_interval_off_ppm').then((value) {
            intervalOffPpm = value;
          });
        }
        if (data['set_interval_on_ppm'] != null) {
          intervalOnPpm = data['set_interval_on_ppm'].toString();
        } else {
          ReadInternalDataOf('set_interval_on_ppm').then((value) {
            intervalOnPpm = value;
          });
        }
        if (data['scheduler_ppm_str'] != null) {
          try {
            list_scheduler_ppm = [];
            scheduler_ppm_str = data['scheduler_ppm_str'].toString();
            Map<String, dynamic> mapData = json.decode(scheduler_ppm_str!);
            List<DateTime> getBlackedList = [];
            final sch = scheduleItemToFirebase.fromJson(mapData);
            sch.data?.forEach(
              (element) {
                final DateTime startDate = DateTime.parse(element.dateFrom!);
                final DateTime toDate = DateTime.parse(element.dateTo!);
                final getBlackedList =
                    ScheduleListTools.getDaysInBeteween(startDate, toDate);
                if (toDate.isAfter(DateTime.now())) {
                  blackedList.addAll(getBlackedList);
                  list_scheduler_ppm?.add(
                    ScheduleItem(
                      fromDate: startDate,
                      toDate: toDate,
                      id: element.id!,
                      ppm: element.ppm!,
                      blackedListItem: getBlackedList,
                    ),
                  );
                }
              },
            );
            ListOfSchedule = list_scheduler_ppm!;
            CheckAndSave('scheduler_ppm_str', scheduler_ppm_str!);
          } catch (e) {
            print('ERRROR ${e.toString()}');
          }
        } else {
          ReadInternalDataOf('scheduler_ppm_str').then((value) {});
        }

        if (data['scheduler_jadwal_penyiraman'] != null) {
          try {
            list_scheduler_ppm = [];
            scheduler_jadwal_penyiraman =
                data['scheduler_jadwal_penyiraman'].toString();
            Map<String, dynamic> mapData =
                json.decode(scheduler_jadwal_penyiraman!);
            final sch = ListJadwalPenyiramanFromToJson.fromJson(mapData);
            sch.data?.forEach(
              (element) {
                list_scheduler_Jadwal_penyiraman?.add(JadwalPenyiraman(
                    id: element.id!,
                    TimeOfDay: element.TimeOfDay!,
                    LamaPenyiraman: element.LamaPenyiraman!));
                ListJadwalPenyiraman = list_scheduler_Jadwal_penyiraman!;
                CheckAndSave(
                  'scheduler_jadwal_penyiraman',
                  scheduler_jadwal_penyiraman!,
                );
              },
            );
          } catch (e) {
            print('ERRROR ${e.toString()}');
          }
        } else {
          ReadInternalDataOf('scheduler_jadwal_penyiraman').then((value) {});
        }
      }
    } catch (err) {
      print('ERROR FROM fromSnapshotSetParameterStatus = $err');
    }
  }
  Sensor.fromSnapshotGrafik(snap, String SensorType) {
    try {
      print('========== ${snap.data.snapshot.value}');
      if (snap.hasData) {
        clearToUpdate(SensorType);
      }
    } catch (err) {
      print('ERROR FROM fromSnapshotGrafik = $err');
    }
  }

  Sensor.fromSnapshotStateButtonPenyiraman(snap) {
    try {
      if (snap.hasData) {
        if (snap.data.snapshot.value == "MATI") {
          stateButtonPenyiramaan = false;
        } else {
          stateButtonPenyiramaan = true;
        }
        // stateButtonPenyiramaan = snap.data.snapshot.value;
        print('[penyiraman] ${snap.data.snapshot.value}');
      }
    } catch (err) {
      print('ERROR FROM [penyiraman] $err');
    }
  }
  Sensor.fromSnapshotStateButtonPengisian(snap) {
    try {
      if (snap.hasData) {
        if (snap.data.snapshot.value == "MATI") {
          stateButtonPengisian = false;
        } else {
          stateButtonPengisian = true;
        }
        print('[stateButtonPengisian] ${snap.data.snapshot.value}');
      }
    } catch (err) {
      print('ERROR FROM [stateButtonPengisian] $err');
    }
  }
  Sensor.fromSnapshotStateButtonPhUp(snap) {
    try {
      if (snap.hasData) {
        if (snap.data.snapshot.value == "MATI") {
          stateButtonPhUp = false;
        } else {
          stateButtonPhUp = true;
        }
        print('[stateButtonPhUp] ${snap.data.snapshot.value}');
      }
    } catch (err) {
      print('ERROR FROM [stateButtonPhUp] $err');
    }
  }
  Sensor.fromSnapshotStateButtonPhDown(snap) {
    try {
      if (snap.hasData) {
        if (snap.data.snapshot.value == "MATI") {
          stateButtonPhDown = false;
        } else {
          stateButtonPhDown = true;
        }
        print('[stateButtonPhDown] ${snap.data.snapshot.value}');
      }
    } catch (err) {
      print('ERROR FROM [stateButtonPhDown] $err');
    }
  }
  Sensor.fromSnapshotStateButtonPpmUp(snap) {
    try {
      if (snap.hasData) {
        if (snap.data.snapshot.value == "MATI") {
          stateButtonPpmUp = false;
        } else {
          stateButtonPpmUp = true;
        }
        print('[stateButtonPpmUp] ${snap.data.snapshot.value}');
      }
    } catch (err) {
      print('ERROR FROM [stateButtonPpmUp] $err');
    }
  }
  Future<void> CheckAndSave(String typeSensor, String valueSensor) async {
    return ReadInternalDataOf(typeSensor).then(
      (valueFromInternal) {
        CheckInternet().then(
          (value) {
            print('[CheckAndSave] saving $typeSensor proccess... ');
            if (valueFromInternal != valueSensor && valueSensor != 'null') {
              InternalPreferences().SaveSensor(typeSensor, valueSensor);
              print('[CheckAndSave] success saving $typeSensor..');
              if (!typeSensor.contains('mode') &&
                  !typeSensor.contains('set_') &&
                  !typeSensor.contains('scheduler')) {
                InternalPreferences().SaveSensor('${typeSensor}UpdateTime',
                    DateTime.now().toIso8601String());
                print('[saving time] update time $typeSensor.. ');
              } else {
                print('[CheckAndSave] !contain');
              }
            } else {
              print('[CheckAndSave] $typeSensor avoid saving...');
            }
          },
        );
      },
    );
  }

  Future<bool> isDataDifferent(String typeSensor, String valueSensor) async {
    return ReadInternalDataOf(typeSensor).then(
      (valueFromInternal) {
        CheckInternet().then(
          (value) {
            if (valueFromInternal != valueSensor && valueSensor != 'null') {
              print(
                  'valueSensor $valueSensor is difference $valueFromInternal ');

              return true;
            } else {
              print(
                  'valueSensor $valueSensor same with intrnal $valueFromInternal ... return false');
            }
          },
        );
        return false;
      },
    );
  }

  void clearToUpdate(String SensorType) {
    if (SensorType == 'ph') {
      GrafikPh = {};
    } else if (SensorType == 'temp') {
      GrafikTemp = {};
    } else if (SensorType == 'humidity') {
      GrafikHumidity = {};
    } else if (SensorType == 'ppm') {
      GrafikPpm = {};
    } else if (SensorType == 'waterTemp') {
      GrafikWaterTemp = {};
    } else if (SensorType == 'statusPompaPenyiraman') {
      GrafikstatusPompaPenyiraman = {};
    }
  }

  void Parsing(snap, String SensorType) {
    final data;
    var map;
    try {
      data = snap.data.snapshot.value;
      printData('data', data);
      map = HashMap.from(data[SensorType]);
    } catch (er) {
      print('error $SensorType reading HashMap');
    }
    //print(map);
    if (SensorType == 'ph') {
      GrafikPh.addAll(map);
    } else if (SensorType == 'temp') {
      GrafikTemp.addAll(map);
    } else if (SensorType == 'humidity') {
      GrafikHumidity.addAll(map);
    } else if (SensorType == 'ppm') {
      GrafikPpm.addAll(map);
    } else if (SensorType == 'waterTemp') {
      GrafikWaterTemp.addAll(map);
    } else if (SensorType == 'statusPompaPenyiraman') {
      GrafikstatusPompaPenyiraman.addAll(map);
    }
  }
}
