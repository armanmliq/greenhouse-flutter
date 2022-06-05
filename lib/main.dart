import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:greenhouse/services/auth.dart';
import 'package:greenhouse/services/notification.dart';
import 'package:greenhouse/services/shared_pref.dart';
import 'package:provider/provider.dart';
import 'constant/constant.dart' as constant;
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'models/sensor.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

String uid = '';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      // This is just a basic example. For real apps, you must show some
      // friendly dialog box before call the request method.
      // This is very important to not harm the user experience
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });
  AwesomeNotifications().initialize(null, // icon for your app notification
      [
        NotificationChannel(
            channelKey: 'key1',
            channelName: 'Proto Coders Point',
            channelDescription: "Notification example",
            defaultColor: Color(0XFF9050DD),
            ledColor: Colors.white,
            playSound: true,
            enableLights: true,
            enableVibration: true)
      ]);
  runApp(
    MaterialApp(home: MyApp()),
  );
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
          },
        ),
        routes: {
          notificaationScreen.routeName: (context) => notificaationScreen(),
          LoginScreen.routeName: (ctx) => const LoginScreen(),
          HomeScreen.routeName: (ctx) => HomeScreen(),
        },
      ),
    );
  }
}
