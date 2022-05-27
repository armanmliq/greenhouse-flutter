import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:greenhouse/constant/constant.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:greenhouse/models/sensor.dart';
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
        List<DateTime> getBlackedList = [];
        final sch = ListJadwalPenyiramanFromToJson.fromJson(mapData);
        final schData = sch.data!;
        ListJadwalPenyiraman.clear();
        for (var i in schData) {
          ListJadwalPenyiraman.add(
            JadwalPenyiraman(
              id: DateTime.now().toString(),
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

      var alert = AlertDialog(
        title: const Text("Berapa menit lama penyiraman? maks 60 min"),
        content: TextField(
          keyboardType: TextInputType.number,
          maxLines: 1,
          autofocus: false,
          enabled: true,
          onSubmitted: (String value) {
            int? number_input;
            try {
              number_input = int.parse(value);
            } catch (e) {
              BotToast.showText(text: 'Gagal');
              return;
            }
            if (number_input > 60) {
              BotToast.showText(text: 'Gagal, maksimal 60 min');
            } else {
              JadwalPenyiramanTools.addJadwalPenyiraman(
                DateTime.now().toString(),
                number_input.toString(),
                ToD.toString(),
              );
            }
            Navigator.of(context, rootNavigator: true).pop();
          },
          controller: textControl,
          decoration: InputDecoration(
            errorStyle: const TextStyle(color: Colors.redAccent),
            border: UnderlineInputBorder(
              borderSide: const BorderSide(
                color: Color.fromRGBO(40, 40, 40, 1.0),
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: const BorderSide(
                color: Color.fromRGBO(40, 40, 40, 1.0),
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            disabledBorder: UnderlineInputBorder(
              borderSide: const BorderSide(
                color: Color.fromRGBO(40, 40, 40, 1.0),
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            prefixIcon: const Icon(
              Icons.timelapse,
              size: 18.0,
            ),
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
        resizeToAvoidBottomInset: false,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              showPicker(
                  context: context,
                  onChange: _onChange,
                  value: TimeOfDay.now()),
            );
          },
          child: const Icon(Icons.add),
        ),
        backgroundColor: const Color.fromARGB(255, 65, 57, 57),
        appBar: AppBar(
          title: const Text('Schedule Penyiraman'),
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
        Sensor sensor = Sensor.fromSnapshotSetParameterStatus(snapshot);
        if (snapshot.hasData) {}
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: ListTile.divideTiles(
              color: Colors.deepPurple,
              tiles: ListJadwalPenyiraman.map(
                (item) {
                  final String waktu =
                      'Time \n${item.TimeOfDay.toString().substring(10, 15)}';
                  final String LamaPenyiraman =
                      'Durasi \n${item.LamaPenyiraman} Menit';
                  return Card(
                    color: Colors.black12,
                    child: ListTile(
                      leading: Container(
                        color: backgroundColor,
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Text(
                            waktu,
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      title: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          LamaPenyiraman,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
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
                              ListJadwalPenyiraman.removeWhere(
                                  (element) => element.id == item.id);
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
