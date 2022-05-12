import 'package:greenhouse/services/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:greenhouse/constant/constant.dart' as constant;

Future<String?> autoLogin() async {
  print('checking any key');
  try {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey('uid')) {
      print('not detected');
      return null;
    }

    print('key detected');

    //-------------------------------------------------------------
    // final decodedData = prefs.getString('userData');
    // final extractedData = json.decode(decodedData!);
    // final extractedAsMap = extractedData as Map<String, dynamic>;

    final uid = prefs.getString('uid');
    constant.uid = uid;

    print('read uid from outside: ${constant.uid}');
    print('detected uid $uid');
    return uid;
    //
  } catch (er) {
    print('ERROR READING SHARED PREFERENCES $er');
  }
}
