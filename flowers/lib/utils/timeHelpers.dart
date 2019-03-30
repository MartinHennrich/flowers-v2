import './dateHelpers.dart';
import '../reminders.dart';

int getDaysLeft(Reminder reminder) {
  DateTime today = preSetTimeFrame(DateTime.now());
  DateTime nextWatertime = preSetTimeFrame(reminder.nextTime);
  Duration diff = nextWatertime.difference(today);

  return (diff.inHours / 24).round();
}
