import 'dart:convert';
import 'dart:math';

import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:greenhouse/constant/constant.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenhouse/constant/constant.dart' as constant;
import 'package:greenhouse/models/jadwal_penyiraman.dart';

import '../services/connectivity.dart';

int? masukanMenitVar;
int? masukanDetikVar;

class JadwalPenyiramanTools {
  static final databaseRef = FirebaseDatabase.instance
      .ref()
      .child('users')
      .child(constant.uid)
      .child("set_parameter");

  static void clearListJadwal() {
    ListJadwalPenyiraman.clear();
  }

  static void removeById(String id) {
    CheckInternet().then((state) {
      if (!state) {
        BotToast.showText(text: 'Check Internet');
      } else {
        ListJadwalPenyiraman.removeWhere((element) => element.id == id);
        updateFirebase();
      }
    });
  }

  static Future<void> setListJadwal() async {
    await JadwalPenyiramanTools.databaseRef
        .child('scheduler_jadwal_penyiraman')
        .get()
        .then((value) {
      final data = value.value.toString();

      print(data);
      if (data == 'null') return;
      try {
        Map<String, dynamic> mapData = {};
        try {
          mapData = json.decode(data);
        } catch (e) {
          print(e);
        }
        final sch = ListJadwalPenyiramanFromToJson.fromJson(mapData);
        final schData = sch.data!;
        ListJadwalPenyiraman.clear();
        for (var i in schData) {
          ListJadwalPenyiraman.add(
            JadwalPenyiraman(
              id: i.id.toString(),
              LamaPenyiraman: i.LamaPenyiraman.toString(),
              TimeOfDay: i.TimeOfDay.toString(),
            ),
          );
        }
      } catch (e) {
        print(e);
      }
    });
  }

  static void addJadwalPenyiraman(
      String id, String LamaPenyiraman, String TimeOfDay) {
    CheckInternet().then(
      (state) {
        if (state) {
          if (ListJadwalPenyiraman.length >= maxSchedulePenyiraman) {
            BotToast.showText(text: 'maximum');
            return;
          }
          BotToast.showText(text: 'Berhasil Menambahkan');
          ListJadwalPenyiraman.add(
            JadwalPenyiraman(
              LamaPenyiraman: LamaPenyiraman,
              id: id,
              TimeOfDay: TimeOfDay,
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
  List<Data> listData = [];
  var index = 0;
  String firebaseDataSend;
  for (final list in ListJadwalPenyiraman) {
    listData.add(
      Data(
        id: list.id.toString(),
        LamaPenyiraman: list.LamaPenyiraman.toString(),
        TimeOfDay: list.TimeOfDay.toString(),
      ),
    );
  }
  final sch = ListJadwalPenyiramanFromToJson(data: listData);
  firebaseDataSend = json.encode(sch.toJson());

  print('send to firebase: $firebaseDataSend');
  final databaseRef = JadwalPenyiramanTools.databaseRef;
  await databaseRef.update(
    {
      'scheduler_jadwal_penyiraman': firebaseDataSend,
    },
  );
}

class JadwalPenyiramanScreen extends StatefulWidget {
  const JadwalPenyiramanScreen({Key? key}) : super(key: key);

  @override
  State<JadwalPenyiramanScreen> createState() => _JadwalPenyiramanScreenState();
}

class _JadwalPenyiramanScreenState extends State<JadwalPenyiramanScreen> {
  TimeOfDay _selectedTime = TimeOfDay.now();
  TextEditingController textControl = TextEditingController();
  final int _currentIntValue = 0;
  @override
  void initState() {
    super.initState();
    JadwalPenyiramanTools.setListJadwal();
  }

  void masukanDetik(var _ToD) {
    masukanDetikVar = 0;
    textControl.clear();
    print(_ToD);
    String number_input = '';
    var masukanDetik = AlertDialog(
      backgroundColor: backgroundColor,
      title: const Text(
        "masukan interval dalam DETIK, max 60",
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
              onChanged: (String value) {
                number_input = value;
              },
              onSubmitted: (String value) {
                number_input = value;
              },
              controller: textControl,
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
                    masukanDetikVar = 0;
                    String numberStr = textControl.text;
                    try {
                      masukanDetikVar = int.parse(numberStr);
                    } catch (e) {
                      BotToast.showText(text: 'Gagal');
                      return;
                    }
                    if (masukanDetikVar! > 60) {
                      BotToast.showText(text: 'maximum 60 detik');
                    } else {
                      int value = masukanDetikVar! + (masukanMenitVar! * 60);
                      JadwalPenyiramanTools.addJadwalPenyiraman(
                        (ListJadwalPenyiraman.length + 1).toString(),
                        value.toString(),
                        _ToD.toString(),
                      );
                      BotToast.showText(text: 'menambahkan..');
                    }
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  child: const Text(
                    'OK',
                    style: TextStyle(color: Colors.white),
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
        return masukanDetik;
      },
    );
  }

  void masukanMenit(ToD) {
    print(ToD);
    masukanMenitVar = 0;
    textControl.clear();
    String number_input = '';
    var masukanMenit = AlertDialog(
      backgroundColor: backgroundColor,
      title: const Text(
        "masukan interval dalam MENIT, max $maxPenyiraman",
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
              onChanged: (String value) {
                number_input = value;
              },
              onSubmitted: (String value) {
                number_input = value;
              },
              controller: textControl,
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
                    masukanMenitVar = 0;
                    String numberStr = textControl.text;
                    try {
                      masukanMenitVar = int.parse(numberStr);
                    } catch (e) {
                      BotToast.showText(text: 'Gagal');
                      return;
                    }
                    if (masukanMenitVar! > maxPenyiraman) {
                      BotToast.showText(text: 'maximum $maxPenyiraman min');
                    } else {
                      // JadwalPenyiramanTools.addJadwalPenyiraman(
                      //   (ListJadwalPenyiraman.length + 1).toString(),
                      //   masukanMenitVar.toString(),
                      //   ToD.toString(),
                      // );
                      BotToast.showText(text: 'menambahkan..');
                    }
                    Navigator.of(context, rootNavigator: true).pop();
                    masukanDetik(ToD);
                  },
                  child: const Text(
                    'OK',
                    style: TextStyle(color: Colors.white),
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
        return masukanMenit;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        resizeToAvoidBottomInset: false,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          onPressed: () {
            Navigator.of(context).push(
              showPicker(
                context: context,
                onChange: masukanMenit,
                value: TimeOfDay.now(),
              ),
            );
          },
          child: const Icon(
            Icons.add,
          ),
        ),
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          title: Text(
            'penyiraman aktif',
            style: TextStyleAppbarTitle,
          ),
          actions: const [],
        ),
        body: const ItemList(),
      ),
    );
  }

  _selectTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != _selectedTime) {
      _selectedTime = timeOfDay;
    }
  }
}

class ItemList extends StatefulWidget {
  const ItemList({Key? key}) : super(key: key);

  @override
  State<ItemList> createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
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
              tiles: ListJadwalPenyiraman.map(
                (item) {
                  String waktu = '';
                  String LamaPenyiraman = '';
                  int _index = 0;
                  try {
                    waktu = item.TimeOfDay.toString().substring(10, 15);
                  } catch (e) {}
                  try {
                    int _menit = int.parse(item.LamaPenyiraman);
                    int minutes = (_menit / 60).truncate();
                    int _detik = int.parse(item.LamaPenyiraman) % 60;
                    // print('[masukan] $_detik $_menit');
                    LamaPenyiraman = '$minutes menit,  $_detik detik';
                  } catch (e) {}
                  try {
                    _index = ListJadwalPenyiraman.indexOf(item) + 1;
                    print('[indexMapJadwalPenyiraman] ${_index + 1}');
                  } catch (e) {}

                  return Card(
                    color: Colors.white70,
                    child: ListTile(
                      leading: Text(
                        _index.toString(),
                        style: GoogleFonts.heebo(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                      title: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              waktu,
                              style: GoogleFonts.anton(
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              LamaPenyiraman,
                              style: const TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                          ],
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
                              JadwalPenyiramanTools.removeById(item.id);
                            },
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ).toList(),
          ),
        );
      },
    );
  }
}
