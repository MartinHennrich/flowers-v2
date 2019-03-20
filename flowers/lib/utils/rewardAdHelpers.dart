import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

final String rewardKey = 'time_reward';

Future<bool> isRemindersUnlocked() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String timeString = (prefs.getString('$rewardKey') ?? null);
  if (timeString == null) {
    return false;
  }
  DateTime today =DateTime.now();
  DateTime timeParsed = DateTime.parse(timeString);

  int daysSenceLastView = today.difference(timeParsed).inDays;
  return daysSenceLastView <= 4;
}

Future<void> setRemindersLockStatus(String time) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return await prefs.setString('$rewardKey', time);
}
