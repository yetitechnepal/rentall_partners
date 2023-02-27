import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotiService {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
      // onDidReceiveLocalNotification:
      //     (int id, String? payload, String? arguement, String? data) {
      //   print(data);
      //   // return Future.value(id);
      // },
    );
    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            macOS: null);
    // Future selectNotification(dynamic payload) async {}

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  listenToFCMNotification() {
    /// Initialize the [FlutterLocalNotificationsPlugin] package.

    // AndroidNotificationChannel channel = const AndroidNotificationChannel(
    //   'rental_partners',
    //   'High Importance Notifications',
    //   description: 'This channel is used for important notifications.',
    //   importance: Importance.max,
    // );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      // RemoteNotification? notification = message.notification;
      // AndroidNotification? android = message.notification?.android;
      // if (notification != null && android != null) {
      //   flutterLocalNotificationsPlugin.show(
      //     notification.hashCode,
      //     notification.title,
      //     notification.body,
      //     NotificationDetails(
      //       android: AndroidNotificationDetails(
      //         channel.id,
      //         channel.name,
      //         channelDescription: channel.description,
      //         icon: 'ic_launcher',
      //       ),
      //     ),
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        "rental_partners", //Required for Android 8.0 or after
        "Rental Partners",
        importance: Importance.max,
        priority: Priority.high, //Required for Android 8.0 or after
        // "Equipment Rental channel", //Required for Android 8.0 or after
      );
      const DarwinNotificationDetails iOSPlatformChannelSpecifics =
          DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );
      NotificationDetails notificationDetails = const NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: iOSPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(
        2,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
      );
    });
  }
}
