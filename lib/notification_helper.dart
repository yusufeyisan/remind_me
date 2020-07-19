import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

NotificationDetails get _ongoing {
  final androidChannelSpecifics = AndroidNotificationDetails(
    "channelId",
    "channelName",
    "channelDescription",
    importance: Importance.Max,
    priority: Priority.High,
    ongoing: true,
    autoCancel: false,
  );
  final iosChannelSpecifics = IOSNotificationDetails();
  return NotificationDetails(androidChannelSpecifics, iosChannelSpecifics);
}

Future showOngoingNotification(
  FlutterLocalNotificationsPlugin notification, {
  @required String title,
  @required String body,
  int id = 0,
  Duration duration = const Duration(seconds: 1),
}) =>
    _showNotification(notification,
        title: title, body: body, duration: duration, type: _ongoing);

Future showScheduledNotification(
  FlutterLocalNotificationsPlugin notification, {
  @required String title,
  @required String body,
  @required Duration duration,
  int id = 0,
}) =>
    _showNotification(notification,
        title: title, body: body, duration: duration, type: _ongoing);

Future _showNotification(
  FlutterLocalNotificationsPlugin notification, {
  @required String title,
  @required String body,
  @required NotificationDetails type,
  @required Duration duration,
  int id = 0,
}) =>
    notification
        .schedule(id, title, body, DateTime.now().add(duration), type)
        .whenComplete(() => print(DateTime.now().second.toString()));
