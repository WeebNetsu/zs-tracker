import 'dart:math';

import 'package:intl/intl.dart';

class SleepModel {
  final DateTime _startTime;
  // duration is in minutes;
  final int _duration;
  // 0 - 5
  late int _rating;

  SleepModel(this._startTime, this._duration, rating) {
    // rating is maxed at 5 and minimumed at 0
    _rating = max(min(rating, 5), 0);
  }

  DateTime getStartTime() {
    return _startTime;
  }

  DateTime getEndTime() {
    return _startTime.add(Duration(minutes: _duration));
  }

  String getDateStr() {
    return DateFormat("dd MMM yyyy").format(_startTime);
  }

  String getStartTimeStr() {
    String hour = _startTime.hour.toString();
    String minute = _startTime.minute.toString();

    if (int.parse(hour) < 10) hour = '0$hour';
    if (int.parse(minute) < 10) minute = '0$minute';

    return "$hour:$minute";
  }

  String getEndTimeStr() {
    DateTime endTime = getEndTime();
    int hours = endTime.hour;
    int minutes = endTime.minute;

    return "${hours < 10 ? '0$hours' : hours}:${minutes < 10 ? '0$minutes' : minutes}";
  }

  int getDuration() {
    return _duration;
  }

  String getDurationHHMM() {
    int hours = (_duration / 60).floorToDouble().toInt();
    int minutes = _duration - (hours * 60);

    return "${hours}h ${minutes < 10 ? '0$minutes' : minutes}m";
  }

  int getRating() {
    return _rating;
  }
}
