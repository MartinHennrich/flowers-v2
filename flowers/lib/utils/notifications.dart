import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/colors.dart';
import '../flower.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
  'com.plant.reminders', 'flowers', 'Reminder to water your flowers',
  color: GreenMain,
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

Future<void> scheduleWaterNotification(String key, String name, DateTime time, DateTime timeOfDayForNotification) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  cancelOldNotification(key, prefs);

  DateTime notificationTime = DateTime(time.year, time.month, time.day,
    timeOfDayForNotification.hour,
    timeOfDayForNotification.minute
  );
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

String getTitleTexts(ReminderType type) {
  switch (type) {
    case ReminderType.Water:
      return 'Water';
    case ReminderType.Fertilize:
      return 'Fertilize';
    case ReminderType.Rotate:
      return 'Rotate';
    default:
      return '';
  }
}

List<String> getBodyTexts(ReminderType type, String name) {
  switch (type) {
    case ReminderType.Water:
      return ['$name wants water', 'Reminder: $name needs water now!'];
    case ReminderType.Fertilize:
      return ['Fertilize $name', 'Reminder: $name wants energy'];
    case ReminderType.Rotate:
      return ['Rotate $name', 'Reminder: $name should be rotated'];
    default:
      return ['', ''];
  }
}

Future<void> _scheduleNotification(SharedPreferences prefs, String name, Reminder reminder) async {
  String key = reminder.key;
  cancelOldNotification(key, prefs);

  DateTime notificationTime = DateTime(reminder.nextTime.year, reminder.nextTime.month, reminder.nextTime.day,
    reminder.timeOfDayForNotification.hour,
    reminder.timeOfDayForNotification.minute
  );
  DateTime reminderTime = notificationTime.add(Duration(days: 1));

  int notisKey = key.hashCode;
  int reminderKey = key.hashCode+1;

  List<String> bodyTexts = getBodyTexts(reminder.type, name);
  Future.wait([
    flutterLocalNotificationsPlugin.schedule(
      notisKey,
      '${getTitleTexts(reminder.type)} time', bodyTexts[0],
      notificationTime,
      platformChannelSpecifics,
      payload: key
    ),
    flutterLocalNotificationsPlugin.schedule(
      reminderKey,
      '${getTitleTexts(reminder.type)} reminder', bodyTexts[1],
      reminderTime,
      platformChannelSpecifics,
      payload: key
    )
  ]);

  saveNotificationKeys(key, [notisKey, reminderKey], prefs);
}

Future<void> scheduleNotificationsForReminders(String name, Reminders reminders) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<Reminder> activeReminders = reminders.getRemindersAsList(sortActive: true);

  activeReminders.forEach((r) {
    _scheduleNotification(prefs, name, r);
  });
}
