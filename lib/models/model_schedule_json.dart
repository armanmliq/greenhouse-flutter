class scheduleItemToFirebase {
  List<Data>? data;

  scheduleItemToFirebase({this.data});

  scheduleItemToFirebase.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? id;
  String? dateFrom;
  String? dateTo;
  String? ppm;

  Data({this.id, this.dateFrom, this.dateTo, this.ppm});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dateFrom = json['dateFrom'];
    dateTo = json['dateTo'];
    ppm = json['ppm'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['dateFrom'] = this.dateFrom;
    data['dateTo'] = this.dateTo;
    data['ppm'] = this.ppm;
    return data;
  }
}
