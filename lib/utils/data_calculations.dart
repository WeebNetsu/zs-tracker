import 'package:zs_tracker/models/sleep.dart';

/// Get the total time slept in a list of sleeps.
Duration calculateTimeSlept(List<SleepModel> sleeps) {
  int minutes = 0;

  for (var sleep in sleeps) {
    minutes += sleep.getDuration();
  }

  return Duration(minutes: minutes);
}

/// Get the total time slept in a list of sleeps.
double calculateAvgSleptRating(List<SleepModel> sleeps) {
  double rating = 0;

  for (var sleep in sleeps) {
    rating += sleep.getRating();
  }

  if (rating <= 0) return 0;

  return rating / sleeps.length;
}

/// Format a duration in format `0d 0h 0m`, if no day or hour, then day or hour will not be displayed
String formatDuration(Duration dur) {
  int totalMinutes = dur.inMinutes;
  if (totalMinutes < 1) return "0m";

  int totalHours = (totalMinutes / 60).floor();
  int days = (totalHours / 24).floor();
  int hours = ((totalMinutes / 60) - (days * 24)).floor();
  int minutes = totalMinutes - (totalHours * 60);

  return "${days > 0 ? '${days}d ' : ''}${hours > 0 ? '${hours}h ' : ''}${minutes > 0 ? '${minutes}m ' : ''}";
}
