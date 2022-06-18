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
        constant.uid = user.uid;
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
}
