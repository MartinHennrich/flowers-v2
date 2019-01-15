import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/colors.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
  'com.plant.reminders', 'flowers', 'Reminder to water your flowers',
  color: BlueMain,
  groupKey: 'water-time',
  importance: Importance.Low,
  priority: Priority.Low
);

NotificationDetails platformChannelSpecifics = NotificationDetails(
  androidPlatformChannelSpecifics,
  null
);

void initNotifications() {
  var initializationSettingsAndroid = AndroidInitializationSettings('ic_stat_app_icon');
  var initializationSettings = InitializationSettings(
    initializationSettingsAndroid, null
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

void cancelOldNotification(String key, SharedPreferences prefs) {
  List<String> keys = (prefs.getStringList('$key-notifications') ?? []);
  List<int> intKeys = keys.map((key) => int.parse(key)).toList();

  intKeys.forEach((key) {
    flutterLocalNotificationsPlugin.cancel(key);
  });
}

Future<void> saveNotificationKeys(String key, List<int> keys SharedPreferences prefs) async {
  await prefs.setStringList('$key-notifications', keys.map((v) => v.toString()).toList());
}

Future<void> scheduleNotification(String key, String name, DateTime time) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  cancelOldNotification(key, prefs);

  DateTime notificationTime = DateTime(time.year, time.month, time.day, 8);
  DateTime reminderTime = notificationTime.add(Duration(days: 1));

  int notisKey = key.hashCode;
  int reminderKey = key.hashCode+1;

  Future.wait([
    flutterLocalNotificationsPlugin.schedule(
      notisKey,
      'Water reminder', '$name wants water',
      notificationTime,
      platformChannelSpecifics,
      payload: key
    ),
    flutterLocalNotificationsPlugin.schedule(
      reminderKey,
      'Water reminder', 'Reminder: $name nees water now!',
      reminderTime,
      platformChannelSpecifics,
      payload: key
    )
  ]);

  saveNotificationKeys(key, [notisKey, reminderKey], prefs);
}

Future<void> rescheduleNotification(String key, name, DateTime time) async {
  scheduleNotification(key, name, time);
}
