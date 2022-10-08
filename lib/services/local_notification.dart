import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

// how to: https://youtu.be/Yrq2llD2Ldw
// local notification is a notifcation provided by the app
// push notification is a notication privided by a server
class LocalNotificationService {
  LocalNotificationService();

  final _localNotificationService = FlutterLocalNotificationsPlugin();

  // when someone clicks a notification with a payload attached
  final BehaviorSubject<String?> onNotificationClick = BehaviorSubject();

  void _onDidReceiveLocalNotification(
    int id,
    String? title,
    String? body,
    String? payload,
  ) {
    debugPrint("ID: $id");
  }

  void _onSelectNotification(String? payload) {
    debugPrint("PAYLOAD $payload");

    if (payload != null && payload.isNotEmpty) {
      onNotificationClick.add(payload);
    }
  }

  Future<void> init() async {
    tz.initializeTimeZones();

    // generate icon here: https://romannurik.github.io/AndroidAssetStudio/
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("@drawable/ic_stat_icon");

    IOSInitializationSettings iosInitializationSettings =
        IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: _onDidReceiveLocalNotification,
    );

    final InitializationSettings settings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await _localNotificationService.initialize(
      settings,
      onSelectNotification: _onSelectNotification,
    );
  }

  Future<NotificationDetails> _notificationDetails() async {
    // todo we can cusomize the channel id and name to group specific
    // notifications, like whatsapp does
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      playSound: true,
    );

    const IOSNotificationDetails iosNotificationDetails =
        IOSNotificationDetails();

    return const NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );
  }

  Future<void> showNotifcation({
    int id = 0,
    required String title,
    required String body,
    // payload is data we can use to pass into our app on notification click
    String? payload,
  }) async {
    final details = await _notificationDetails();

    await _localNotificationService.show(
      id,
      title,
      body,
      details,
      payload: payload,
    );
  }

  Future<void> showSheduledNotifcation({
    int id = 0,
    required String title,
    required String body,
    required int seconds,
  }) async {
    final details = await _notificationDetails();

    await _localNotificationService.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(
          DateTime.now().add(Duration(seconds: seconds)), tz.local),
      details,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
