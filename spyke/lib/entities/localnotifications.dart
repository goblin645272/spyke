import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotification {
  static FlutterLocalNotificationsPlugin flutterNotificationPlugin;
  static AndroidNotificationDetails androidSettings;

  static Initializer() {
    flutterNotificationPlugin = FlutterLocalNotificationsPlugin();
    androidSettings = AndroidNotificationDetails(
        "111", "Background_task_Channel", "Channel to test background task",
        enableLights: true,
        enableVibration: true,
        largeIcon: DrawableResourceAndroidBitmap('notif_icon'),
        styleInformation: MediaStyleInformation(),
        importance: Importance.high,
        priority: Priority.max);
    var androidInitialization = AndroidInitializationSettings('app_icon');
    var initializationSettings =
        InitializationSettings(android: androidInitialization);
    flutterNotificationPlugin.initialize(
      initializationSettings,
    );
  }

  static ShowPositiveDeltaNotif(
      DateTime scheduledDate, String x, String y, String z, String n) async {
    var notificationDetails = NotificationDetails(android: androidSettings);
    await flutterNotificationPlugin.schedule(1, "$x has crossed your delta $n",
        "Current price :$y  Delta set: $z.", scheduledDate, notificationDetails,
        androidAllowWhileIdle: true);
  }

  static ShowDayendNotif(
      DateTime scheduledDate, String x, String y, String z) async {
    var notificationDetails = NotificationDetails(android: androidSettings);
    await flutterNotificationPlugin.schedule(
        1,
        "It is recommended to $x stock \n$y",
        "Current price :$z",
        scheduledDate,
        notificationDetails,
        androidAllowWhileIdle: true);
  }

  static CancelNotification(int notificationid) async {
    await flutterNotificationPlugin.cancel(notificationid);
  }
}
