import 'package:shared_preferences/shared_preferences.dart';
import 'package:greenhouse/constant/constant.dart' as constant;

import 'initialize_account.dart';

class InternalPreferences {
  Future<String?> prefsRead(String type) async {
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

  Future<void> prefsSave(String type, var val) async {
    if (val == 'null') {
      print('avoid.saving! data is null');
      return;
    }
    var value = val.toString();
    if (value.isNotEmpty) {
      try {
        final prefs = await SharedPreferences.getInstance();
        print('c.$type .. $value');
        prefs.setString(type, value);
      } catch (er) {
        //print('error Save.Sensor: $er');
      }
    }
  }
}

Future<String> checkSavedUid() async {
  print('>>>>>>>> checkSavedUid >>>>>>');
  final prefs = await SharedPreferences.getInstance();
  final userUid = prefs.getString('userUid') ?? '';
  constant.uid = userUid;
  print('>>>>>>>>>>>>> $userUid >>>>>>');
  if (userUid.isNotEmpty) {
    await initializeAccount();
  }
  return userUid;
}
