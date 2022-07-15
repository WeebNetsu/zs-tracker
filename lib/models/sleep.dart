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

  SleepModel(this._startTime, this._endTime, int rating, this._notes,
      {String? id}) {
    _id = id ?? uuid.v4();
    // rating is maxed at 5 and minimumed at 0
    _rating = max(min(rating, 5), 0);
  }

  SleepModel.fromJSON(dynamic json)
      : this(
          DateTime.parse(json['start']),
          DateTime.parse(json['end']),
          json['rating'],
          json['notes'],
          id: json['id'],
        );

  Map<String, dynamic> toJson() => {
        'id': _id,
        'start': _startTime.toString(),
        'end': _endTime.toString(),
        'rating': _rating,
        'notes': _notes,
      };

  DateTime getStartTime() => _startTime;
  String getDateStr() => DateFormat("dd MMM yyyy").format(_startTime);
  int getDuration() => _endTime.difference(_startTime).inMinutes;
  int getRating() => _rating;
  String getNotes() => _notes;

  String getStartTimeStr() {
    String hour = _startTime.hour.toString();
    String minute = _startTime.minute.toString();

    if (int.parse(hour) < 10) hour = '0$hour';
    if (int.parse(minute) < 10) minute = '0$minute';

    return "$hour:$minute";
  }

  String getEndTimeStr() {
    int hours = _endTime.hour;
    int minutes = _endTime.minute;

    return "${hours < 10 ? '0$hours' : hours}:${minutes < 10 ? '0$minutes' : minutes}";
  }

  String getDurationHHMM() {
    int dur = getDuration();
    int hours = (dur / 60).floorToDouble().toInt();
    int minutes = dur - (hours * 60);

    return "${hours}h ${minutes < 10 ? '0$minutes' : minutes}m";
  }
}
