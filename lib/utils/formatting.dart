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
