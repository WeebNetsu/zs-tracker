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

/// Convert DateTime.month to it's string form
///
/// ie. `convertMonthToString(DateTime.january) -> "january"`
String convertMonthToString(int month) {
  if (month > 12 || month < 1) {
    throw RangeError("Is invalid, has to be between 1 and 12");
  }

  switch (month) {
    case DateTime.january:
      return "january";
    case DateTime.february:
      return "february";
    case DateTime.march:
      return "march";
    case DateTime.april:
      return "april";
    case DateTime.may:
      return "may";
    case DateTime.june:
      return "june";
    case DateTime.july:
      return "july";
    case DateTime.august:
      return "august";
    case DateTime.september:
      return "september";
    case DateTime.october:
      return "october";
    case DateTime.november:
      return "november";
  }

  return "december";
}
