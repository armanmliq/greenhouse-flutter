List<JadwalPenyiraman> ListJadwalPenyiraman = [];

class JadwalPenyiraman {
  final String id;
  final String TimeOfDay;
  final String LamaPenyiraman;
  JadwalPenyiraman({
    required this.id,
    required this.TimeOfDay,
    required this.LamaPenyiraman,
  });
}

class ListJadwalPenyiramanFromToJson {
  List<Data>? data;

  ListJadwalPenyiramanFromToJson({this.data});

  ListJadwalPenyiramanFromToJson.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? id;
  String? TimeOfDay;
  String? LamaPenyiraman;

  Data(
      {required this.id,
      required this.TimeOfDay,
      required this.LamaPenyiraman});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    TimeOfDay = json['TimeOfDay'];
    LamaPenyiraman = json['LamaPenyiraman'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['TimeOfDay'] = this.TimeOfDay;
    data['LamaPenyiraman'] = this.LamaPenyiraman;
    return data;
  }
}
