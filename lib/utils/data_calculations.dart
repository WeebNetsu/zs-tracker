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
