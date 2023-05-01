import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelGroupKey: 'reminders',
        channelKey: 'instant_notification',
        channelName: 'Basic Instant Notification',
        channelDescription:
        'Notification channel that can trigger notification instantly.',
        defaultColor: const Color(0xFF9D50DD),
        ledColor: Colors.white,
      ),
      NotificationChannel(
        channelGroupKey: 'reminders',
        channelKey: 'scheduled_notification',
        channelName: 'Scheduled Notification',
        channelDescription:
        'Notification channel that can trigger notification based on predefined time.',
        defaultColor: const Color(0xFF9D50DD),
        ledColor: Colors.white,
      ),
    ],
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () async {
                  await Notify.instantNotify('First Notification', 'This is my first notification');
                },
                child: const Text("Instant Notification "),
              ),
              TextButton(
                onPressed: () async {
                  await Notify.scheduleNotification();
                },
                child: const Text("Schedule Notification "),
              ),
              TextButton(
                onPressed: () async {
                  await Notify.retrieveScheduledNotifications();
                },
                child: const Text("Retrieve Scheduled Notifications"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class Notify {
  static Future<bool> instantNotify(String title, String body) async {
    final AwesomeNotifications awesomeNotifications = AwesomeNotifications();
    return await awesomeNotifications.createNotification(
      content: NotificationContent(
        id: Random().nextInt(100),
        title: '$title',
        body: "$body",
        channelKey: 'instant_notification',
        notificationLayout: NotificationLayout.BigPicture,
        bigPicture: 'asset://images/moon.jpg',
      ),
    );
  }

  static Future<bool> scheduleNotification() async {
    final AwesomeNotifications awesomeNotifications = AwesomeNotifications();
    return await awesomeNotifications.createNotification(
      schedule: NotificationInterval(interval: 60),
      content: NotificationContent(
        id: Random().nextInt(100),
        title: "Scheduled Notification",
        body:
        "So this notification will get triggered when it's 9 pm on my device and the date is December 9, 2021.",
        channelKey: 'scheduled_notification',
        wakeUpScreen: true,
        autoDismissible: false,
        notificationLayout: NotificationLayout.BigPicture,
        bigPicture: 'asset://images/moon.jpg',
        category: NotificationCategory.Reminder,
      ),
    );
  }

  static Future<void> retrieveScheduledNotifications() async {
    final AwesomeNotifications awesomeNotifications = AwesomeNotifications();
    List<NotificationModel> scheduledNotifications =
    await awesomeNotifications.listScheduledNotifications();
    print(scheduledNotifications);
  }
}