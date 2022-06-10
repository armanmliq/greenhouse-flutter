import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:greenhouse/models/firebaseException.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:greenhouse/services/shared_pref.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:greenhouse/constant/constant.dart' as constant;
import '../constant/constant.dart';
import 'initialize_account.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String userId = '';

  bool get isAuth {
    if (userId.isNotEmpty) {
      return true;
    }
    return false;
  }

  //sign in anon
  Future<String?> signInAnon() async {
    try {
      //
      final authResult = await _auth.signInAnonymously();
      constant.uid = authResult.user!.uid;
      return constant.uid;
    } catch (err) {
      print(err);
      return null;
    }
  }

  //sign in email pass
  Future<String> signIn(String email, String password) async {
    try {
      //try call auth
      final authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      final user = authResult.user;
      print(user!);

      //if request success
      if (user.uid.isNotEmpty) {
        constant.uid = user.uid;
        print('Before Initialize userId = ${constant.uid}');
        try {
          await initializeAccount();
        } catch (e) {
          print('error from initializeAccount $e');
        }
        //save auth to memory
        final _prefs = await SharedPreferences.getInstance();
        print('======= login success auth will save ${constant.uid}=========');
        try {
          final uid = await _prefs.setString('userUid', user.uid.toString());
          print('=========NOW I PRINT $uid');
        } catch (er) {
          print('sharedPrefs Error! $er');
        }
        notifyListeners();
      }
      return user.uid;
    } on FirebaseAuthException catch (e) {
      throw FirebaseOnError(
          e.message.toString()); // Or extend this with a custom exception class
    } catch (err) {
      print('signIn on catch ${err}');
      rethrow;
    }
  }

  //sign up email pass
  Future<bool?> signUp(String email, String password, String username) async {
    try {
      //
      final authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      final user = authResult.user;

      // //push new uid in document while first register
      if (user!.uid.isNotEmpty) {
        isRegister = true;
        print('[REGISTER] $email $password $username');
        initialEmail = email;
        initialPass = password;
        initialUsername = username;
        InternalPreferences().prefsSave('email', email).then((value) {
          InternalPreferences().prefsSave('password', password).then((value) {
            InternalPreferences().prefsSave('username', username).then((value) {
              initializeAccount();
            });
          });
        });

        return true;
      }
      return false;
    } on FirebaseAuthException catch (err) {
      print(err);
      throw FirebaseOnError(err.message.toString());
    } catch (e) {
      rethrow;
    }
  }

  Future<bool?> tryAutoLogin() async {
    print('checking any key');
    try {
      final prefs = await SharedPreferences.getInstance();

      if (!prefs.containsKey('userUid')) {
        print('not detected');
        return false;
      }

      print('========== key detected ==============');

      //-------------------------------------------------------------

      final uid = jsonDecode(prefs.getString('userUid')!);
      constant.uid = uid;
      //
      print('========== detected uid $userId ==========');
      notifyListeners();
    } catch (er) {
      print('ERROR READING SHARED PREFERENCES $er');
    }
    return true;
  }

  //--------------------------------------------------
  void logout() async {
    await _auth.signOut();
    final prefs = await SharedPreferences.getInstance();
    final decodedData = prefs.remove('userUid');
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    notifyListeners();
  }
  //--------------------------------------------------

  // initializeAccount() async {
  //   print('================= CALLING INITIALIZE >====================');

  //   //

  //   try {
  //     final sensor = FirebaseDatabase.instance
  //         .ref()
  //         .child('users')
  //         .child(constant.uid)
  //         .child("sensor_status");
  //     await sensor.get().then(
  //           (DocumentSnapshot) => {
  //             if (!DocumentSnapshot.exists)
  //               {
  //                 // ignore: avoid_print
  //                 print('initialize sensor_status not exist, CREATE ONE'),
  //                 sensor.set({
  //                   'humidity': "50",
  //                   'ph': "6.0",
  //                   'ppm': "1000",
  //                   'tankLevel': "50",
  //                   'temperature': "20.0",
  //                   'sprayer_status': "MATI",
  //                   'pompa_status': "MATI",
  //                   'pompa_nutrisi_status': "MATI",
  //                 }),
  //               }
  //             else
  //               {
  //                 print('initialize sensor_status data EXIST'),
  //               }
  //           },
  //         );
  //   } catch (er) {
  //     print('ersensor_status $er');
  //   }

  //   try {
  //     final setParameter = FirebaseDatabase.instance
  //         .ref()
  //         .child('users')
  //         .child(constant.uid)
  //         .child("set_parameter");
  //     setParameter.get().then(
  //           // ignore: non_constant_identifier_names
  //           (DocumentSnapshot) => {
  //             if (!DocumentSnapshot.exists)
  //               {
  //                 print('initialize set_parameter not exist, CREATE ONE'),
  //                 setParameter.set({
  //                   'set_humidity': '20',
  //                   'set_ppm': '1000',
  //                   'set_ph': '6',
  //                   'set_moisture_off': '90',
  //                   'set_moisture_on': '60',
  //                 }),
  //               }
  //             else
  //               {
  //                 print('initialize set_parameter data EXIST'),
  //               }
  //           },
  //         );
  //   } catch (er) {
  //     print('ersetParameter $er');
  //   }
  //   try {
  //     final PH = FirebaseDatabase.instance
  //         .ref()
  //         .child('users')
  //         .child(constant.uid)
  //         .child("grafik")
  //         .child('PH');
  //     PH.get().then(
  //           // ignore: non_constant_identifier_names
  //           (DocumentSnapshot) => {
  //             if (!DocumentSnapshot.exists)
  //               {
  //                 print('initialize PH not exist, CREATE ONE'),
  //                 PH.set({
  //                   "1652776630": "237",
  //                   "1652777530": "274",
  //                   "1652778430": "389",
  //                   "1652779330": "348",
  //                   "1652780230": "262",
  //                   "1652781130": "350",
  //                   "1652782030": "273",
  //                   "1652782930": "255",
  //                   "1652783830": "253",
  //                   "1652784730": "395",
  //                   "1652785630": "453",
  //                   "1652786530": "325",
  //                   "1652787430": "377",
  //                   "1652788330": "243",
  //                   "1652789230": "335",
  //                   "1652790130": "380",
  //                   "1652791030": "495",
  //                   "1652791930": "324",
  //                 }),
  //               }
  //             else
  //               {
  //                 print('initialize PH data EXIST'),
  //               }
  //           },
  //         );
  //   } catch (er) {
  //     print('erPH $er');
  //   }
  //   try {
  //     final PPM = FirebaseDatabase.instance
  //         .ref()
  //         .child('users')
  //         .child(constant.uid)
  //         .child("grafik")
  //         .child('PPM');
  //     PPM.get().then(
  //           // ignore: non_constant_identifier_names
  //           (DocumentSnapshot) => {
  //             if (!DocumentSnapshot.exists)
  //               {
  //                 print('initialize PPM not exist, CREATE ONE'),
  //                 PPM.set({
  //                   "1652776630": "237",
  //                   "1652777530": "274",
  //                   "1652778430": "389",
  //                   "1652779330": "348",
  //                   "1652780230": "262",
  //                   "1652781130": "350",
  //                   "1652782030": "273",
  //                   "1652782930": "255",
  //                   "1652783830": "253",
  //                   "1652784730": "395",
  //                   "1652785630": "453",
  //                   "1652786530": "325",
  //                   "1652787430": "377",
  //                   "1652788330": "243",
  //                   "1652789230": "335",
  //                   "1652790130": "380",
  //                   "1652791030": "495",
  //                   "1652791930": "324",
  //                   "1652792830": "338",
  //                   "1652793730": "390",
  //                   "1652794630": "397",
  //                   "1652795530": "463",
  //                   "1652796430": "222",
  //                 }),
  //               }
  //             else
  //               {
  //                 print('initialize PH data EXIST'),
  //               }
  //           },
  //         );
  //   } catch (er) {
  //     print('erPPM $er');
  //   }
  //   try {
  //     final TEMPERATURE = FirebaseDatabase.instance
  //         .ref()
  //         .child('users')
  //         .child(constant.uid)
  //         .child("grafik")
  //         .child('TEMPERATURE');
  //     TEMPERATURE.get().then(
  //           // ignore: non_constant_identifier_names
  //           (DocumentSnapshot) => {
  //             if (!DocumentSnapshot.exists)
  //               {
  //                 print('initialize TEMPERATURE not exist, CREATE ONE'),
  //                 TEMPERATURE.set({
  //                   "1652790028": "5.1",
  //                   "1652790088": "4.8",
  //                   "1652790148": "4.7",
  //                   "1652790208": "5.3",
  //                   "1652790268": "4.5",
  //                   "1652790328": "5.7",
  //                   "1652790388": "5.3",
  //                   "1652790448": "4.2",
  //                   "1652790508": "5.4",
  //                   "1652790568": "5.1",
  //                   "1652790628": "20"
  //                 }),
  //               }
  //             else
  //               {
  //                 print('initialize TEMPERATURE data EXIST'),
  //               }
  //           },
  //         );
  //   } catch (er) {
  //     print('erTEMPERATURE $er');
  //   }
  //   try {
  //     final HUMIDITY = FirebaseDatabase.instance
  //         .ref()
  //         .child('users')
  //         .child(constant.uid)
  //         .child("grafik")
  //         .child('HUMIDITY');
  //     HUMIDITY.get().then(
  //           (DocumentSnapshot) => {
  //             if (!DocumentSnapshot.exists)
  //               {
  //                 print('initialize HUMIDITY not exist, CREATE ONE'),
  //                 HUMIDITY.set({
  //                   "1652776630": "237",
  //                   "1652777530": "274",
  //                   "1652778430": "389",
  //                   "1652779330": "348",
  //                   "1652780230": "262",
  //                   "1652781130": "350",
  //                   "1652782030": "273",
  //                   "1652782930": "255",
  //                   "1652783830": "253",
  //                   "1652784730": "395",
  //                   "1652785630": "453",
  //                   "1652786530": "325",
  //                   "1652787430": "377",
  //                   "1652788330": "243",
  //                   "1652789230": "335",
  //                   "1652790130": "380",
  //                   "1652791030": "495",
  //                 }),
  //               }
  //             else
  //               {
  //                 print('initialize HUMIDITY data EXIST'),
  //               }
  //           },
  //         );
  //   } catch (er) {
  //     print('erHUMIDITY $er');
  //   }
  //   print('================= END OF CALLING INITIALIZE ====================');
  // }
}
