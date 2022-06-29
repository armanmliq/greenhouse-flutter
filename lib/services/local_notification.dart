import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class LocalNotification {
  static Future<void> showNotification(String title, String message) async {
    // Parsing ID Notifikasi
    int secondsSinceEpoch =
        DateTime.now().millisecondsSinceEpoch ~/ Duration.millisecondsPerSecond;
    const int idNotification = 1;

    // Daftar jenis notifikasi dari aplikasi.
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'BBD',
      'Notification',
      importance: Importance.max,
      priority: Priority.high,
    );

    const IOSNotificationDetails iOSPlatformChannelSpecifics =
        IOSNotificationDetails();

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    // Menampilkan Notifikasi
    await flutterLocalNotificationsPlugin.show(
        1, title, message, platformChannelSpecifics);
  }

  Future<void> notificationHandler() async {
    // Pengaturan Notifikasi

    // AndroidInitializationSettings default value is 'app_icon'
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    /// Note: permissions aren't requested here just to demonstrate that can be
    /// done later
    const IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    // Handling notifikasi yang di tap oleh pengguna
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (String? payload) async {
        // TODO
      },
    );
  }
}
