import 'package:flutter/material.dart';
import 'package:greenhouse/constant/constant.dart';
import 'package:greenhouse/models/sensor_history.dart';
import 'package:intl/intl.dart';

final f = DateFormat('yyyy-MM-dd hh:mm');
bool _stateColor = true;

class reportTable extends StatelessWidget {
  reportTable({required this.SensorHistoryList, required this.sensorType});

  final List<SensorHistory> SensorHistoryList;
  final String sensorType;
  @override
  Widget build(BuildContext context) {
    late String header;
    switch (sensorType) {
      case 'ph':
        header = 'ph air';
        break;
      case 'ppm':
        header = 'ppm air';
        break;
      case 'temp':
        header = 'suhu ruangan';
        break;
      case 'humidity':
        header = 'kelembapan ruangan';
        break;
      case 'waterTemp':
        header = 'suhu air';
        break;
      case 'statusPompaPenyiraman':
        header = 'penyiraman';
        break;
      default:
    }
    List<Map<String, dynamic>> _data = [];
    SensorHistoryList.map((e) {
      return _data.add({'unix': e.unix, 'value': e.ValueSensor});
    });
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(padding),
          child: PaginatedDataTable(
            headingRowHeight: 30,
            rowsPerPage: 10,
            header: Text(
              "Report $header",
            ),
            source: UserDataTableSource(
              SensorHistoryList: SensorHistoryList,
              sensorType: sensorType,
            ),
            columnSpacing: 60,
            horizontalMargin: 10,
            showCheckboxColumn: false,
            columns: const <DataColumn>[
              DataColumn(
                label: Text(
                  'NO',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'WAKTU',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'VALUE',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          color: Colors.blue,
          child: TextButton(
            onPressed: () {},
            child: const Text(
              'DOWNLOAD REPORT KEMARIN',
              style: TextStyle(color: Colors.white),
            ),
          ),
        )
      ],
    );
  }
}

class UserDataTableSource extends DataTableSource {
  UserDataTableSource({
    required this.sensorType,
    required List<SensorHistory> SensorHistoryList,
  }) : _userData = SensorHistoryList;

  final List<SensorHistory> _userData;
  final String sensorType;

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);

    if (index >= _userData.length) {
      return null;
    }
    final _user = _userData[index];
    late String value;
    switch (sensorType) {
      case 'ph':
        value = _user.ValueSensor.toStringAsFixed(1);
        break;
      case 'ppm':
        value = _user.ValueSensor.toStringAsFixed(0);
        break;
      case 'temp':
        value = _user.ValueSensor.toStringAsFixed(1);
        break;
      case 'humidity':
        value = _user.ValueSensor.toStringAsFixed(1);
        break;
      case 'waterTemp':
        value = _user.ValueSensor.toStringAsFixed(1);
        break;
      case 'statusPompaPenyiraman':
        value = _user.ValueSensor == 1 ? 'HIDUP' : 'MATI';
        break;
      default:
    }
    _stateColor = !_stateColor;
    final Color gridColor =
        _stateColor ? Colors.blue.shade100 : Colors.blue.shade50;
    return DataRow.byIndex(
      color: MaterialStateProperty.all(gridColor),
      index: index,
      cells: <DataCell>[
        DataCell(Text('#${(index + 1).toString()}')),
        DataCell(Text(f.format(_user.unix))),
        DataCell(Text(value)),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _userData.length;

  @override
  int get selectedRowCount => 0;
}
