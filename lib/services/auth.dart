import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:greenhouse/models/firebaseException.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:greenhouse/constant/constant.dart' as constant;

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
      final user = authResult.user;
      return user!.uid;
    } catch (err) {
      print(err);
      return null;
    }
  }

  //sign in email pass
  Future<String?> signIn(String email, String password) async {
    try {
      //try call auth
      final authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      final user = authResult.user;
      print(user!);

      //if request success
      if (user.uid.isNotEmpty) {
        constant.uid = user.uid;
        print('Before Initialize userId = ${user.uid}');
        try {
          initializeAccount();
        } catch (e) {
          print('error from initializeAccount $e');
        }
        //save auth to memory
        final _prefs = await SharedPreferences.getInstance();
        print('======= login success auth will save $user.uid =========');
        try {
          final prefs = await _prefs.setString('uid', user.uid);
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

  initializeAccount() {
    DocumentReference sensor = FirebaseFirestore.instance
        .collection('users')
        .doc(constant.uid)
        .collection('sensor_status')
        .doc(constant.uid);
    sensor.get().then(
          (DocumentSnapshot) => {
            if (!DocumentSnapshot.exists)
              {
                print('initialize data not exist, CREATE ONE'),
                sensor.set({
                  'humidity': "50",
                  'ph': "6.0",
                  'ppm': "1000",
                  'tankLevel': "50",
                  'temperature': "20.0",
                }),
              }
            else
              {
                print('initialize sensor_status data EXIST'),
              }
          },
        );
    DocumentReference control_status = FirebaseFirestore.instance
        .collection('users')
        .doc(constant.uid)
        .collection('control_status')
        .doc(constant.uid);
    control_status.get().then(
          (DocumentSnapshot) => {
            if (!DocumentSnapshot.exists)
              {
                print('initialize data not exist, CREATE ONE'),
                control_status.set({
                  'pompa_status': 'OFF',
                  'pompa_nutrisi_status': 'ON',
                  'sprayer_status': 'ON'
                }),
              }
            else
              {
                print('initialize control_status data EXIST'),
              }
          },
        );
    DocumentReference set_parameter = FirebaseFirestore.instance
        .collection('users')
        .doc(constant.uid)
        .collection('set_parameter')
        .doc(constant.uid);
    control_status.get().then(
          (DocumentSnapshot) => {
            if (!DocumentSnapshot.exists)
              {
                print('initialize data not exist, CREATE ONE'),
                set_parameter.set({
                  'set_humidity': '20',
                  'set_ppm': '1000',
                }),
              }
            else
              {
                print('initialize set_parameter data EXIST'),
              }
          },
        );
  }

  //sign up email pass
  Future<bool?> signUp(String? email, String? password) async {
    try {
      //
      final authResult = await _auth.createUserWithEmailAndPassword(
          email: email!, password: password!);
      final user = authResult.user;

      //push new uid in document while first register
      if (user!.uid.isNotEmpty) {
        print('passing uid not null');

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

      if (!prefs.containsKey('uid')) {
        print('not detected');
        return false;
      }

      print('key detected');

      //-------------------------------------------------------------
      // final decodedData = prefs.getString('userData');
      // final extractedData = json.decode(decodedData!);
      // final extractedAsMap = extractedData as Map<String, dynamic>;

      final uid = prefs.getString('uid');

      userId = uid!;
      //
      print('detected uid $userId');
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
    final decodedData = prefs.remove('uid');
    notifyListeners();
  }

  void set setUid(String s) {
    print('SET THE UIT $s');
    userId = s;
  }
  //--------------------------------------------------

}
