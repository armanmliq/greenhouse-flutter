import 'dart:developer';

import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:greenhouse/services/auth.dart';
import 'package:greenhouse/services/local_notification.dart';
import 'package:greenhouse/services/shared_pref.dart';
import 'package:provider/provider.dart';
import 'constant/constant.dart' as constant;
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'models/sensor.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title description
  importance: Importance.high,
  playSound: true,
);

// flutter local notification
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// firebase background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  LocalNotification.showNotification(notification!.title!, notification.body!);
  print('A Background message just showed up :  ${message.messageId}');
}

void onSubs() {
  LocalNotification.showNotification('mes', 'mes');
}

String uid = '';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await LocalNotification().notificationHandler();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  constant.FCM_TOKEN = (await FirebaseMessaging.instance.getToken())!;
  log('[ID] ${constant.FCM_TOKEN}');
  // Firebase local notification plugin
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  constant.uid = await checkSavedUid();
  log('[ID] UID: ${constant.uid}');

  if (constant.uid.isNotEmpty && constant.uid != 'null') {
    await FirebaseMessaging.instance.subscribeToTopic(constant.uid);
  }
  //Firebase messaging
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(
    MaterialApp(home: MyApp()),
  );
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        LocalNotification.showNotification(
            notification.title!, notification.body!);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new messageopen app event was published');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        LocalNotification.showNotification(
            notification.title!, notification.body!);
      }
    });
  }

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
          LoginScreen.routeName: (ctx) => const LoginScreen(),
          HomeScreen.routeName: (ctx) => HomeScreen(),
        },
      ),
    );
  }
}
