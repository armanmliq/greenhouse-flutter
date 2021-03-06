import 'dart:core';
import 'dart:developer';
import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:greenhouse/constant/constant.dart';
import 'package:greenhouse/services/connectivity.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:flutter/material.dart';
import 'package:greenhouse/constant/constant.dart' as constant;
import 'dart:convert';
import 'package:greenhouse/models/model_schedule_json.dart';

final DateRangePickerController _controller = DateRangePickerController();
String formatParsingdatePicker = r'(\d{4})[-](\d{2})[-](\d{2})';
RegExp regExp = RegExp(formatParsingdatePicker);
List<DateTime> blackedList = [];
List<ScheduleItem> listOfSchedule = [];
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
    listOfSchedule.clear();
  }

  static void removeById(String id) {
    List<DateTime> getBlackedList = [];
    CheckInternet().then((state) {
      if (!state) {
        BotToast.showText(text: 'Check Internet');
      } else {
        blackedList.clear();
        listOfSchedule.removeWhere((element) => element.id == id);
        for (var i in listOfSchedule) {
          getBlackedList = getDaysInBeteween(i.fromDate, i.toDate);
          blackedList.addAll(getBlackedList);
        }
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
          listOfSchedule.clear();
          blackedList.clear();
          for (var i in schData) {
            final DateTime startDate = DateTime.parse(i.dateFrom!);
            final DateTime toDate = DateTime.parse(i.dateTo!);
            getBlackedList =
                ScheduleListTools.getDaysInBeteween(startDate, toDate);
            if (toDate.isAfter(DateTime.now())) {
              blackedList.addAll(getBlackedList);
              ScheduleListTools.getDaysInBeteween(startDate, toDate);
              listOfSchedule.add(
                ScheduleItem(
                  fromDate: startDate,
                  toDate: toDate,
                  id: i.id!,
                  ppm: i.ppm!,
                  blackedListItem: blackedList,
                ),
              );
            }
          }
        } catch (e) {
          print(e);
        }
      },
    );
  }

  static void addScheduleItem(
    DateTime? fromDate,
    DateTime? toDate,
    String ppm,
  ) {
    List<DateTime> getBlackedList;
    getBlackedList = [];
    getBlackedList = getDaysInBeteween(fromDate!, toDate!);
    CheckInternet().then(
      (state) {
        if (state) {
          if (listOfSchedule.length >= maxSchedulePpm) {
            BotToast.showText(text: 'max $maxSchedulePpm jadwal');
            return;
          }
          BotToast.showText(text: 'Berhasil Menambahkan');
          listOfSchedule.add(
            ScheduleItem(
              fromDate: fromDate,
              id: (listOfSchedule.length + 1).toString(),
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
  for (final i in listOfSchedule) {
    print(i.blackedListItem);
    blackedList.addAll(i.blackedListItem);
  }
  print(blackedList.length);

  List<Data> listData = [];
  final x = DateFormat('yyyy-MM-dd');
  var index = 0;
  String firebaseDataSend;
  for (final list in listOfSchedule) {
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
    // BotToast.showText(text: args.value);
    // print(args.value);
  }

  bool ParseFromPickerDateTimer(String str) {
    fromDate = null;
    toDate = null;
    // int i = 0;
    // print('try parse $str');
    // final matches = regExp.allMatches(str).map((m) => m[0]);
    // for (final m in matches) {
    //   if (m!.length > 4) {
    //     if (i == 0) {
    //       fromDate = DateTime.parse(m);
    //     } else {
    //       toDate = DateTime.parse(m);
    //     }
    //     i++;
    //   }
    // }
    if (_controller.selectedRange?.startDate != null &&
        _controller.selectedRange?.endDate != null) {
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
        "masukan target ppm? \nmaximum $maxPpm",
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
                          _controller.selectedRange?.startDate,
                          _controller.selectedRange?.endDate,
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
                        rangeTextStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                        controller: _controller,
                        todayHighlightColor: Colors.white,
                        backgroundColor: Colors.grey,
                        startRangeSelectionColor: Colors.blue,
                        endRangeSelectionColor: Colors.blue,
                        selectionColor: Colors.blue,
                        showNavigationArrow: true,
                        rangeSelectionColor: Colors.blue,
                        onCancel: () {
                          Navigator.pop(context);
                        },
                        onSubmit: (_) {
                          log("====================== >>>>>>>>>>> ${_controller.selectedRange?.startDate}");
                          log("====================== >>>>>>>>>>> ${_controller.selectedRange?.endDate}");
                          BotToast.showText(
                              text:
                                  'xx - ${_controller.selectedRange.toString()}');
                          if (ParseFromPickerDateTimer(
                              _controller.selectedRange.toString())) {
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          title: Text(
            'JADWAL NUTRISI',
            style: TextStyleAppbarTitle,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
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
            if (snapshot.hasData) {}
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: ListTile.divideTiles(
                  color: Colors.deepPurple,
                  tiles: listOfSchedule.map(
                    (item) => Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Card(
                        color: Colors.white70,
                        child: ListTile(
                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${item.ppm.toString()} PPM',
                                  style: TextStyleJadwalValue,
                                ),
                              ],
                            ),
                          ),
                          leading: Text(
                            '${listOfSchedule.indexOf(item) + 1}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                          subtitle: Text(
                            '${f.format(item.fromDate).toString()} to ${f.format(item.toDate).toString()}',
                            style: const TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
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
