import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

final String whatsNewKey = 'whats-new-update-1';

Future<bool> shouldSeeWhatsNew(bool isFirstTime) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool showWhatsNew = (prefs.getBool('$whatsNewKey') ?? true);

    if (showWhatsNew || isFirstTime) {
      await prefs.setBool('$whatsNewKey', false);
    }

    if (isFirstTime) {
      return false;
    }

    return showWhatsNew;
  } catch (e) {
    print('failed whats new');
  }

  return false;
}
