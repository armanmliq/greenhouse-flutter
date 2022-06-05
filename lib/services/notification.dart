import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

void Notify() async {
  String timezom = await AwesomeNotifications().getLocalTimeZoneIdentifier();
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
        id: 1,
        channelKey: 'key1',
        title: 'This is Notification title',
        body: 'This is Body of Noti',
        bigPicture:
            'https://protocoderspoint.com/wp-content/uploads/2021/05/Monitize-flutter-app-with-google-admob-min-741x486.png',
        notificationLayout: NotificationLayout.BigPicture),
    schedule:
        NotificationInterval(interval: 2, timeZone: timezom, repeats: true),
  );
}

class notificaationScreen extends StatefulWidget {
  static const routeName = '/navigationPage';
  @override
  _notificaationScreenState createState() => _notificaationScreenState();
}

class _notificaationScreenState extends State<notificaationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Notify(); //localnotification method call below
                // when user top on notification this listener will work and user will be navigated to notification page
                AwesomeNotifications()
                    .actionStream
                    .listen((receivedNotifiction) {});
              },
              child: Text("Local Notification"),
            ),
          ],
        ),
      ),
    );
  }
}
