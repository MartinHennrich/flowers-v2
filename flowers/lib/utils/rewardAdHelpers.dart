import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

final String rewardKey = 'time_reward';
final String labelRewardKey = 'label_reward_key';

Future<bool> isRewardUnlocked(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String timeString = (prefs.getString('$key') ?? null);
  if (timeString == null) {
    return false;
  }
  DateTime today =DateTime.now();
  DateTime timeParsed = DateTime.parse(timeString);

  int daysSenceLastView = today.difference(timeParsed).inDays;
  return daysSenceLastView <= 2;
}

Future<void> setRewardLockStatus(String key, String time) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return await prefs.setString('$key', time);
}
