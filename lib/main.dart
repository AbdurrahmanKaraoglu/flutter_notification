import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_call_notification_test/home_page.dart';
import 'package:flutter_call_notification_test/second_page.dart';
import 'package:flutter_call_notification_test/service/notification_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) async {
  // ignore: avoid_print
  print('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');

  // bildirimi reddetme işlemi
  // bildirimi kapat
  await flutterLocalNotificationsPlugin.cancel(notificationResponse.id!);
  if (notificationResponse.input?.isNotEmpty ?? false) {
    // ignore: avoid_print
    print('notification action tapped with input: ${notificationResponse.input}');
  }
}

/// IMPORTANT: running the following code on its own won't work as there is
/// setup required for each platform head project.
///
/// Please download the complete example app from the GitHub repository where
/// all the setup has been done
Future<void> main() async {
  // needed if you intend to initialize in the `main` function
  WidgetsFlutterBinding.ensureInitialized();

  await _configureLocalTimeZone();

  final NotificationAppLaunchDetails? notificationAppLaunchDetails = !kIsWeb && Platform.isLinux ? null : await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  String initialRoute = HomePage.routeName;
  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    // Uygulama bildirim ile açıldı ise
    // Uygulama terminate iken bildirime tıklandığı zaman burdan yönlendirme yapılıyor.
    selectedNotificationPayload = notificationAppLaunchDetails!.notificationResponse?.payload;
    notiId = notificationAppLaunchDetails.notificationResponse?.id ?? 0;
    // initailRoute = SecondPage olarak değiştirildi.
    initialRoute = SecondPage.routeName;
  }

  NotificationService.forgroundNotification();

  runApp(
    GetMaterialApp(
      initialRoute: initialRoute,
      routes: <String, WidgetBuilder>{
        HomePage.routeName: (_) => HomePage(notificationAppLaunchDetails),
        SecondPage.routeName: (_) => SecondPage(selectedNotificationPayload, notiID: notiId, isRoute: true),
      },
    ),
  );
}

Future<void> _configureLocalTimeZone() async {
  if (kIsWeb || Platform.isLinux) {
    return;
  }
  tz.initializeTimeZones();
  final String timeZoneName = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName));
}
