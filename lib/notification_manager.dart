import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:remind_me/screens/home.dart';

import 'notification_helper.dart';

// ignore: must_be_immutable
class NotificationManager extends StatefulWidget {
  Duration d;

  NotificationManager(this.d);

  @override
  _NotificationManagerState createState() => _NotificationManagerState(d);
}

class _NotificationManagerState extends State<NotificationManager> {
  @required
  Duration d;
  _NotificationManagerState(this.d);

  final notification = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    final androidSetings = AndroidInitializationSettings("app_icon");
    final iosSettings = IOSInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) =>
            onSelectNotification(payload));

    notification.initialize(InitializationSettings(androidSetings, iosSettings),
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) async => await Navigator.push(
      context, MaterialPageRoute(builder: (context) => HomePage()));

  @override
  Widget build(BuildContext context) => Scaffold(
          body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text(
                  "Notifications",
                  style: TextStyle(
                      letterSpacing: 1.2,
                      color: Colors.black87,
                      fontSize: 24.0,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ];
        },
        body: ListView(
          children: <Widget>[
            RaisedButton(
              child: Text("Show notification"),
              color: Theme.of(context).colorScheme.background,
              onPressed: () => showOngoingNotification(notification,
                  title: "Title", body: "Body"),
            ),
            RaisedButton(
              child: Text("Show notification after 5 seconds"),
              color: Theme.of(context).colorScheme.background,
              onPressed: () => showScheduledNotification(notification,
                  title: "Title", body: "Body", duration: Duration(seconds: 5)),
            )
          ],
        ),
      ));
}
