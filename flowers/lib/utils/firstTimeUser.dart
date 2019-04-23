import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

final String firstTimeUserKey = 'first-time-user';

Future<bool> isFirstTimeUser() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool firstTimeUser = (prefs.getBool('$firstTimeUserKey') ?? true);
    if (firstTimeUser) {
      await prefs.setBool('$firstTimeUserKey', false);
    }

    return firstTimeUser;
  } catch (e) {
    print('failed is new user');
  }

  return false;
}
