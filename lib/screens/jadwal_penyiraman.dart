import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:greenhouse/constant/constant.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenhouse/constant/constant.dart' as constant;
import 'package:greenhouse/models/jadwal_penyiraman.dart';

import '../services/connectivity.dart';

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
            BotToast.showText(text: 'max $maxSchedulePenyiraman jadwal');
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
  JadwalPenyiramanScreen({Key? key}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    void _onChange(ToD) {
      print(ToD);
      String number_input = '';
      var alert = AlertDialog(
        backgroundColor: backgroundColor,
        title: const Text(
          "interval penyiraman aktif in minute\nmaks $maxPenyiraman min",
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
                      int? number;
                      String numberStr = textControl.text;
                      try {
                        number = int.parse(numberStr);
                      } catch (e) {
                        BotToast.showText(text: 'Gagal');
                        return;
                      }
                      if (number > maxPenyiraman) {
                        BotToast.showText(text: 'maximum $maxPenyiraman min');
                      } else {
                        JadwalPenyiramanTools.addJadwalPenyiraman(
                          (ListJadwalPenyiraman.length + 1).toString(),
                          number.toString(),
                          ToD.toString(),
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
          return alert;
        },
      );
    }

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
                onChange: _onChange,
                value: TimeOfDay.now(),
              ),
            );
          },
          child: const Icon(
            Icons.add,
          ),
        ),
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          title: Text(
            'Schedule Penyiraman',
            style: TextStyleAppbarTitle,
          ),
          actions: [],
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
                    LamaPenyiraman = '${item.LamaPenyiraman} Menit';
                  } catch (e) {}
                  try {
                    _index = ListJadwalPenyiraman.indexOf(item) + 1;
                    print('[indexMapJadwalPenyiraman] ${_index + 1}');
                  } catch (e) {}

                  return Card(
                    color: Colors.white,
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
                                color: Colors.black,
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
