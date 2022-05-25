import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:greenhouse/services/auth.dart';
import 'package:greenhouse/services/shared_pref.dart';
import 'package:provider/provider.dart';
import 'constant/constant.dart' as constant;
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'models/sensor.dart';
import 'screens/ppm_datetime_picker.dart';

String uid = '';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: AuthService()),
        ChangeNotifierProvider.value(value: Sensor()),
      ],
      child: MaterialApp(
        builder: BotToastInit(),
        title: 'Smart Greenhouse',
        theme: ThemeData(
          fontFamily: 'Lato',
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
              .copyWith(secondary: Colors.deepOrange),
          primaryColor: constant.backgroundColor,
          backgroundColor: constant.backgroundColor,
          appBarTheme:
              const AppBarTheme(color: Color.fromARGB(255, 22, 97, 92)),
        ),
        home: FutureBuilder<String?>(
            future: checkSavedUid(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                print('>>> ${snapshot.data} <<<');
                return HomeScreen();
              } else {
                return const LoginScreen();
              }
            }),
        routes: {
          LoginScreen.routeName: (ctx) => const LoginScreen(),
          HomeScreen.routeName: (ctx) => HomeScreen(),
        },
      ),
    );
  }
}
