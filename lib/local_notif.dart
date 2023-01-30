import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotif {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static init() async {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher_foreground');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
        final String? payload = notificationResponse.payload;
        if (payload != null) {
          debugPrint('notification payload: $payload');
        }
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  @pragma('vm:entry-point')
  static void notificationTapBackground(NotificationResponse notificationResponse) {
    // handle action
  }

  static Priority parsePriority(String? priorityStr) {
    if (priorityStr == null) return Priority.defaultPriority;
    var priority = int.tryParse(priorityStr) ?? 3;
    return Priority(priority - 3);
  }

  static Map<String, String> decodeMessage(Uint8List u8message) {
    String message = utf8.decode(u8message);
    List<String> params = Uri.decodeComponent(message).split("&");
    Map<String, String> decoded = {};
    for (var param in params) {
      var paramSplitted = param.split("=");
      if (paramSplitted.length == 2) decoded[paramSplitted[0]] = paramSplitted[1];
    }

    return decoded;
  }

  static showNotif(Uint8List u8message) async {
    Map<String, String> decodedMessage = decodeMessage(u8message);
    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'default_channel',
      'default_channel_name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: parsePriority(decodedMessage["priority"] ?? "3"),
      ticker: 'ticker',
    );

    NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
      0,
      decodedMessage["title"] ?? "N/A",
      decodedMessage["message"] ?? "N/A",
      notificationDetails,
    );
  }
}
