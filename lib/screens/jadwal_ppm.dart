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
final f = DateFormat('dd MMMM yyyy');

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
      .child("set_parameter");

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
    await ScheduleListTools.databaseRef.child('scheduler_ppm_str').get().then(
      (value) {
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
            for (var i in ListOfSchedule) {
              print(i.ppm);
            }
          }
        } catch (e) {
          print(e);
        }
      },
    );
  }

  static void addScheduleItem(
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
          if (ListOfSchedule.length >= maxSchedulePpm) {
            BotToast.showText(text: 'max $maxSchedulePpm jadwal');
            return;
          }
          BotToast.showText(text: 'Berhasil Menambahkan');
          ListOfSchedule.add(
            ScheduleItem(
              fromDate: fromDate,
              id: (ListOfSchedule.length + 1).toString(),
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
  print('send to firebase scheduler_ppm_str: $firebaseDataSend');
  final databaseRef = ScheduleListTools.databaseRef;
  await databaseRef.update({
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

  void showDialogInput() {
    String _targetPpm = '';
    var alert = AlertDialog(
      backgroundColor: backgroundColor,
      title: const Text(
        "Berapa target ppm? \nmaximum ${maxPpm}",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      content: Container(
        color: backgroundColor,
        height: 130,
        child: Column(
          children: [
            TextField(
              style: const TextStyle(
                color: Colors.white,
              ),
              keyboardType: TextInputType.number,
              maxLines: 1,
              autofocus: false,
              enabled: true,
              onChanged: (value) {
                _targetPpm = value;
              },
              decoration: InputDecoration(
                errorStyle: const TextStyle(color: Colors.redAccent),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.white,
                    width: 3,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.white,
                    width: 3,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.white,
                    width: 3,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                prefixIcon: const Icon(
                  Icons.confirmation_num,
                  color: Colors.white,
                  size: 18.0,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  child: const Text(
                    'CANCEL',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (_targetPpm.contains(',') || _targetPpm.contains('.')) {
                      BotToast.showText(text: 'ppm tidak boleh decimal');
                      return;
                    }
                    if (double.parse(_targetPpm) > maxPpm) {
                      BotToast.showText(text: 'ppm harus dibawah $maxPpm');
                    } else {
                      setState(() {
                        ScheduleListTools.addScheduleItem(
                          fromDate!,
                          toDate!,
                          _targetPpm,
                        );
                      });
                    }
                    print('Get $_targetPpm');
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  child: const Text(
                    'OK',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );

    showDialog(
      context: context,
      builder: (context) {
        return alert;
      },
    );
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
                            showDialogInput();
                          } else {
                            BotToast.showText(text: 'Gagal menambah waktu');
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          title: const Center(
            child: Text('Jadwal Nutrisi'),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: 'btn1',
          onPressed: () {
            ShowDateTimePicker();
          },
          child: const Icon(Icons.add),
        ),
        body: StreamBuilder(
          stream: FirebaseDatabase.instance
              .ref()
              .child('users')
              .child(constant.uid)
              .child('set_parameter')
              .onValue,
          builder: (context, snapshot) {
            Sensor sensor = Sensor.fromSnapshotSchedulerPpm(snapshot);
            if (snapshot.hasData) {}
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: ListTile.divideTiles(
                  color: Colors.deepPurple,
                  tiles: ListOfSchedule.map(
                    (item) => Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Card(
                        color: Colors.black12,
                        child: ListTile(
                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${item.ppm.toString()} PPM',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          leading: Text(
                            '${ListOfSchedule.indexOf(item) + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Text(
                            '${f.format(item.fromDate).toString()} To ${f.format(item.toDate).toString()}',
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.white,
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
            );
          },
        ),
      ),
    );
  }
}
