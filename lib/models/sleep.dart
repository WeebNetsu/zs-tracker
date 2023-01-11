import 'dart:math';

import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class SleepModel {
  final DateTime _startTime, _endTime;
  // duration is in minutes;
  // final int _duration;
  // 0 - 5
  late int _rating;
  final String _notes;
  late String _id;
  final uuid = const Uuid();

  SleepModel(this._startTime, this._endTime, int rating, this._notes, {String? id}) {
    _id = id ?? uuid.v4();
    // rating is maxed at 5 and minimumed at 0
    _rating = max(min(rating, 5), 0);
  }

  /// Create a modal from JSON (Map) data
  SleepModel.fromJSON(dynamic json)
      : this(
          DateTime.parse(json['start']),
          DateTime.parse(json['end']),
          json['rating'],
          json['notes'],
          id: json['id'],
        );

  /// Convert model data to JSON format
  Map<String, dynamic> toJson() => {
        'id': _id,
        'start': _startTime.toString(),
        'end': _endTime.toString(),
        'rating': _rating,
        'notes': _notes,
      };

  /// Get start time date as a string in format `dd MMM yyyy` (ie. 15 Jul 2022)
  String getStartDateStr() => DateFormat("dd MMM yyyy").format(_startTime);
  String getEndDateStr() => DateFormat("dd MMM yyyy").format(_endTime);

  String get id => _id;
  DateTime get startTime => _startTime;
  DateTime get endTime => _endTime;

  /// Get sleep duration in minutes
  int get duration => _endTime.difference(_startTime).inMinutes;
  int get rating => _rating;
  String get notes => _notes;

  /// Get start time as a string. ie. `19:02`
  String getStartTimeStr() {
    String hour = _startTime.hour.toString();
    String minute = _startTime.minute.toString();

    if (int.parse(hour) < 10) hour = '0$hour';
    if (int.parse(minute) < 10) minute = '0$minute';

    return "$hour:$minute";
  }

  /// Get end time as a string. ie. `19:02`
  String getEndTimeStr() {
    int hours = _endTime.hour;
    int minutes = _endTime.minute;

    return "${hours < 10 ? '0$hours' : hours}:${minutes < 10 ? '0$minutes' : minutes}";
  }

  /// Get sleep duration as an HH:MM string
  String getDurationHHMM() {
    int dur = duration;
    int hours = (dur / 60).floorToDouble().toInt();
    int minutes = dur - (hours * 60);

    return "${hours}h ${minutes < 10 ? '0$minutes' : minutes}m";
  }
}
