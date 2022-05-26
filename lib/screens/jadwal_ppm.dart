import 'dart:core';
import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:greenhouse/constant/constant.dart';
import 'package:greenhouse/models/sensor.dart';
import 'package:greenhouse/services/connectivity.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:flutter/material.dart';
import 'package:greenhouse/constant/constant.dart' as constant;
import 'dart:convert';
import 'package:greenhouse/models/model_schedule_json.dart';

String FormatParsingdatePicker = r'(\d{4})[-](\d{2})[-](\d{2})';
RegExp regExp = RegExp(FormatParsingdatePicker);
List<DateTime> blackedList = [];
List<ScheduleItem> ListOfSchedule = [];
DateTime? fromDateStr;
DateTime? toDateStr;
final f = DateFormat('dd-MM-yyyy');

class ScheduleItem {
  final String id;
  final DateTime fromDate;
  final DateTime toDate;
  final String ppm;
  final List<DateTime> blackedListItem;

  ScheduleItem({
    required this.fromDate,
    required this.id,
    required this.toDate,
    required this.ppm,
    required this.blackedListItem,
  });
}

class ScheduleListTools {
  static final databaseRef = FirebaseDatabase.instance
      .ref()
      .child('users')
      .child(constant.uid)
      .child("scheduler");

  static List<DateTime> getDaysInBeteween(
      DateTime startDate, DateTime endDate) {
    List<DateTime> days = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(
        DateTime(startDate.year, startDate.month, startDate.day + i),
      );
    }
    return days;
  }

  static void clearListSchedule() {
    ListOfSchedule.clear();
  }

  static void removeById(String id) {
    CheckInternet().then((state) {
      if (!state) {
        BotToast.showText(text: 'Check Internet');
      } else {
        ListOfSchedule.removeWhere((element) => element.id == id);
        updateFirebase();
      }
    });
  }

  static Future<void> setScheduleByString() async {
    await ScheduleListTools.databaseRef
        .child('scheduler_ppm_str')
        .get()
        .then((value) {
      final data = value.value.toString();
      print(data);
      if (value.value == null) return;
      try {
        Map<String, dynamic> mapData = {};
        try {
          mapData = json.decode(data);
        } catch (e) {
          print(e);
        }
        List<DateTime> getBlackedList = [];
        final sch = scheduleItemToFirebase.fromJson(mapData);
        final schData = sch.data!;
        ListOfSchedule.clear();
        blackedList.clear();
        for (var i in schData) {
          final DateTime startDate = DateTime.parse(i.dateFrom!);
          final DateTime toDate = DateTime.parse(i.dateTo!);
          getBlackedList =
              ScheduleListTools.getDaysInBeteween(startDate, toDate);
          if (toDate.isAfter(DateTime.now())) {
            blackedList.addAll(getBlackedList);
            ScheduleListTools.getDaysInBeteween(startDate, toDate);
            ListOfSchedule.add(
              ScheduleItem(
                fromDate: startDate,
                toDate: toDate,
                id: i.id!,
                ppm: i.ppm!,
                blackedListItem: blackedList,
              ),
            );
          }
          print('BLACKED LISt $blackedList');
        }
      } catch (e) {
        print(e);
      }
    });
  }

  static void addScheduleItem(
    String id,
    DateTime fromDate,
    DateTime toDate,
    String ppm,
  ) {
    List<DateTime> getBlackedList;
    getBlackedList = [];
    getBlackedList = getDaysInBeteween(fromDate, toDate);
    CheckInternet().then(
      (state) {
        if (state) {
          BotToast.showText(text: 'Berhasil Menambahkan');
          ListOfSchedule.add(
            ScheduleItem(
              fromDate: fromDate,
              id: id,
              toDate: toDate,
              ppm: ppm,
              blackedListItem: getBlackedList,
            ),
          );
          updateFirebase();
        } else {
          BotToast.showText(text: 'Check Internet');
        }
      },
    );
  }
}

Future<void> updateFirebase() async {
  blackedList = [];
  for (final i in ListOfSchedule) {
    print(i.blackedListItem);
    blackedList.addAll(i.blackedListItem);
  }
  print(blackedList.length);

  List<Data> listData = [];
  final x = DateFormat('yyyy-MM-dd');
  var index = 0;
  String firebaseDataSend;
  for (final list in ListOfSchedule) {
    listData.add(
      Data(
        id: list.id.toString(),
        dateFrom: x.format(list.fromDate).toString(),
        dateTo: x.format(list.toDate).toString(),
        ppm: list.ppm.toString(),
      ),
    );
  }
  final sch = scheduleItemToFirebase(data: listData);
  firebaseDataSend = json.encode(sch.toJson());
  print('send to firebase: $firebaseDataSend');
  final databaseRef = ScheduleListTools.databaseRef;
  await databaseRef.set({
    'scheduler_ppm_str': firebaseDataSend,
  });
}

class JadwalPpmScreen extends StatefulWidget {
  const JadwalPpmScreen({Key? key}) : super(key: key);

  @override
  State<JadwalPpmScreen> createState() => JadwalPpmScreenState();
}

DateTime? fromDate;
DateTime? toDate;

class JadwalPpmScreenState extends State<JadwalPpmScreen> {
  @override
  void initState() {
    ScheduleListTools.setScheduleByString();
    print('INITTT');
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    print(args.value);
  }

  bool ParseFromPickerDateTimer(String str) {
    fromDate = null;
    toDate = null;
    int i = 0;
    print('try parse $str');
    final matches = regExp.allMatches(str).map((m) => m[0]);
    for (final m in matches) {
      if (m!.length > 4) {
        if (i == 0) {
          fromDate = DateTime.parse(m);
        } else {
          toDate = DateTime.parse(m);
        }
        i++;
      }
    }
    if (fromDate.toString() != 'null' && toDate.toString() != 'null') {
      return true;
    } else {
      return false;
    }
  }

  void ShowDateTimePicker() {
    showDialog(
      context: context,
      builder: (context) {
        return SizedBox(
          width: 300,
          height: 300,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  color: Colors.blue,
                ),
                Dialog(
                  elevation: 16,
                  child: Column(
                    children: [
                      SfDateRangePicker(
                        showNavigationArrow: true,
                        onCancel: () {
                          Navigator.pop(context);
                        },
                        onSubmit: (p0) {
                          if (ParseFromPickerDateTimer(p0.toString())) {
                            BotToast.showText(
                                text: 'waktu ditambahkan, masukan ppm');
                            Navigator.pop(context);
                            ShowInputPpm();
                          } else {
                            BotToast.showText(text: 'gagal menambahkan waktu');
                            Navigator.pop(context);
                          }
                        },
                        showActionButtons: true,
                        showTodayButton: true,
                        minDate: DateTime.now(),
                        maxDate: DateTime.now().add(
                          const Duration(days: 60),
                        ),
                        monthViewSettings: DateRangePickerMonthViewSettings(
                          blackoutDates: blackedList,
                        ),
                        onSelectionChanged: _onSelectionChanged,
                        selectionMode: DateRangePickerSelectionMode.range,
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

  void ShowInputPpm() {
    showDialog(
      context: context,
      builder: (context) {
        int maxPpm = 1300;
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Dialog(
            child: SizedBox(
              width: 150,
              height: 100,
              child: Center(
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    label: Text('Masukan ppm (maksimal $maxPpm)'),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1,
                      ),
                    ),
                  ),
                  onSubmitted: (value) {
                    if (double.parse(value) > maxPpm) {
                      BotToast.showText(
                          text: 'gagal menambahkan, ppm harus dibawah $maxPpm');
                      print('ListOfSchedule.length ${ListOfSchedule.length}');
                    } else {
                      print('ListOfSchedule.length ${ListOfSchedule.length}');
                      setState(() {
                        ScheduleListTools.addScheduleItem(
                          DateTime.now().toString(),
                          fromDate!,
                          toDate!,
                          value,
                        );
                      });
                    }
                    print('Get $value');
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          title: const Center(child: Text('Atur jadwal ppm')),
        ),
        body: SafeArea(
          child: StreamBuilder(
            stream: FirebaseDatabase.instance
                .ref()
                .child('users')
                .child(constant.uid)
                .child('scheduler')
                .onValue,
            builder: (context, snapshot) {
              Sensor sensor = Sensor.fromSnapshotSchedulerPpm(snapshot);
              if (snapshot.hasData) {}
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: ListTile.divideTiles(
                        color: Colors.deepPurple,
                        tiles: ListOfSchedule.map(
                          (item) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              elevation: 5,
                              child: ListTile(
                                leading: Container(
                                  color: Colors.amber,
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Text(
                                      '${item.toDate.difference(item.fromDate).inDays + 1} Hari',
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                title: Text(
                                  'PPM = ${item.ppm.toString()}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  '${f.format(item.fromDate).toString()} to ${f.format(item.toDate).toString()}',
                                  style: const TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                  ),
                                  onPressed: () {
                                    setState(
                                      () {
                                        ScheduleListTools.removeById(item.id);
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ).toList(),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Center(
                        child: FloatingActionButton(
                          heroTag: 'btn1',
                          onPressed: () {
                            ShowDateTimePicker();
                          },
                          child: const Icon(Icons.add),
                        ),
                      ),
                    ],
                  ),
                  FloatingActionButton(
                    heroTag: 'btn2',
                    onPressed: () async {
                      print(blackedList);
                    },
                    child: const Center(child: Icon(Icons.search)),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}