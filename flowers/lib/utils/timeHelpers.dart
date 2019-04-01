import '../reminders.dart';
import './dateHelpers.dart';

int getDaysLeft(Reminder reminder) {
  DateTime today = preSetTimeFrame(DateTime.now());
  DateTime nextWatertime = preSetTimeFrame(reminder.nextTime);
  Duration diff = nextWatertime.difference(today);

  int daysLeft = (diff.inHours / 24).round();
  return daysLeft < 0 ? 0 : daysLeft;
}
