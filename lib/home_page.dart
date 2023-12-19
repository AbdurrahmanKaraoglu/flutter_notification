import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_call_notification_test/padded_elevated_button.dart';
import 'package:flutter_call_notification_test/service/notification_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class HomePage extends StatefulWidget {
  const HomePage(
    this.notificationAppLaunchDetails, {
    Key? key,
  }) : super(key: key);

  static const String routeName = '/';

  final NotificationAppLaunchDetails? notificationAppLaunchDetails;

  bool get didNotificationLaunchApp => notificationAppLaunchDetails?.didNotificationLaunchApp ?? false;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  NotificationService? notiService;

  @override
  void initState() {
    notiService = NotificationService();
    notiListen();
    super.initState();
  }

  Future<void> notiListen() async {
    notiService!.isAndroidPermissionGranted();
    notiService!.requestPermissions();

    notiService!.configureSelectNotificationSubject();
  }

  @override
  void dispose() {
    didReceiveLocalNotificationStream.close();
    selectNotificationStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Center(
              child: Column(
                children: <Widget>[
                  const Text(
                    'Notifications with actions',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  PaddedElevatedButton(
                    buttonText: 'Show notification with plain actions',
                    onPressed: () async {
                      await notiService!.showNotificationWithActions();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
