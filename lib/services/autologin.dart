// import 'package:greenhouse/services/auth.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:greenhouse/constant/constant.dart' as constant;

// Future<String?> autoLogin() async {
//   print('checking any saved users');
//   try {
//     final prefs = await SharedPreferences.getInstance();
//     if (!prefs.containsKey('userUid')) {
//       print('prefs users not detected');
//       return null;
//     }
//     print('key detected');
//     //-------------------------------------------------------------
//     final userUid = prefs.getString('userUid')!;
//     constant.uid = userUid;
//     print('detected uid ${userUid}');

//     await initializeAccount();
//     return userUid;
//     //
//   } catch (er) {
//     print('ERROR READING SHARED PREFERENCES $er');
//     throw (er);
//   }
// }
