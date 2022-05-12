import 'package:flutter/material.dart';
import 'package:greenhouse/services/auth.dart';
import 'package:greenhouse/services/autologin.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import './models/sensor.dart';
import 'constant/constant.dart' as constant;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final uid = await autoLogin();
  runApp(MaterialApp(home: MyApp(uid)));
}

class MyApp extends StatelessWidget {
  final uid;
  MyApp(this.uid);
  @override
  Widget build(BuildContext context) {
    print('MYAPP UID =  ${constant.uid}');
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: AuthService()),
        ChangeNotifierProvider.value(value: Sensor()),
      ],
      child: MaterialApp(
        title: 'Smart Greenhouse',
        theme: ThemeData(
          fontFamily: 'Lato',
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
              .copyWith(secondary: Colors.deepOrange),
          primaryColor: constant.bgColor,
          backgroundColor: constant.backgroundColor,
          appBarTheme:
              const AppBarTheme(color: Color.fromARGB(255, 22, 97, 92)),
        ),
        home: constant.uid != null ? HomeScreen() : LoginScreen(),
        routes: {
          LoginScreen.routeName: (ctx) => LoginScreen(),
          HomeScreen.routeName: (ctx) => HomeScreen(),
        },
      ),
    );
  }
}
