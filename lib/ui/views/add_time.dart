import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:zs_tracker/models/sleep.dart';
import 'package:zs_tracker/ui/widgets/input.dart';
import 'package:zs_tracker/utils/app.dart' as utils;

class AddTimePageArguments {
  final SleepModel? sleepData;

  AddTimePageArguments(this.sleepData);
}

class AddTimePage extends StatefulWidget {
  const AddTimePage({super.key, required this.title});

  final String title;

  @override
  State<AddTimePage> createState() => _AddTimePageState();
}

class _AddTimePageState extends State<AddTimePage> {
  DateTime? _startDate, _endDate;
  String? _id; // if editing and not adding
  bool _loading = true;

  final Map<String, dynamic> _error = {
    "show": false,
    "message": "Some error has happened"
  };
  int _rating = 0;
  final _notesField = TextEditingController();

  void _getNewDateTime(bool setStartDate) async {
    // if we're setting the end date before the start date
    if (!setStartDate && _startDate == null) return;

    final DateTime? date = await showDatePicker(
      context: context,
      initialDate:
          setStartDate ? _startDate ?? DateTime.now() : _endDate ?? _startDate!,
      firstDate: setStartDate ? DateTime.parse("2022-01-01") : _startDate!,
      lastDate: DateTime.now(),
    );

    if (date == null) return;

    TimeOfDay? time;
    // bool getTime = !setStartDate && date.day == _startDate!.day;

    time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time == null) return;

    DateTime dateNoTime = DateTime.parse(DateFormat("yyyy-MM-dd").format(date));
    setState(() {
      if (setStartDate) {
        _startDate = dateNoTime.add(
          Duration(hours: time!.hour, minutes: time.minute),
        );
      } else {
        _endDate = dateNoTime.add(
          Duration(hours: time!.hour, minutes: time.minute),
        );
      }

      _error["show"] = false;

      if (!setStartDate && date.day == _startDate!.day) {
        if (_startDate!.hour > time.hour ||
            _startDate!.hour == time.hour && _startDate!.minute > time.minute) {
          setState(() {
            _error["show"] = true;
            _error["message"] = "End time is invalid";
          });
          return;
        }
      }
    });
  }

  String _getTimeHHMMStr(int min) {
    final int hours = (min / 60).floor();
    final int minutes = min - (hours * 60);

    return "${hours}h ${minutes}m";
  }

  bool _allowSave() {
    if (_error["show"]) return false;
    if (_startDate == null || _endDate == null) return false;

    return true;
  }

  void _saveData() async {
    Directory? appDir = await utils.getAppDir();

    if (_startDate == null || _endDate == null || appDir == null) return;

    // if (_notesField.text.isEmpty) return;

    final data = SleepModel(_startDate!, _endDate!, _rating, _notesField.text);

    // create will not overwrite existing data
    final newFile = await File("${appDir.path}/save.json").create();

    try {
      // if the file is empty, don't append , at the start of the json!
      if (newFile.readAsLinesSync().isEmpty) {
        await newFile.writeAsString(
          jsonEncode(data.toJson()),
          mode: FileMode.append,
        );
      } else {
        await newFile.writeAsString(
          ",${jsonEncode(data.toJson())}",
          mode: FileMode.append,
        );
      }

      finishUp();
    } catch (err) {
      print(err);
    }
  }

  void _editData() async {
    Directory? appDir = await utils.getAppDir();

    if (_startDate == null || _endDate == null || appDir == null) return;

    final newFile = File("${appDir.path}/save.json");

    if (!(await newFile.exists())) return;

    try {
      final fileText = await newFile.readAsString();

      if (fileText.isEmpty) {
        finishUp();
        return;
      }

      final sleepJson = jsonDecode("[$fileText]");
      String newSleeps = "";
      for (var sleep in sleepJson) {
        var modal = SleepModel.fromJSON(sleep);

        // if it's the modal we're looking for, overwrite it
        if (modal.id == _id) {
          modal = SleepModel(_startDate!, _endDate!, _rating, _notesField.text,
              id: _id);
        }

        newSleeps += "${jsonEncode(modal.toJson())},";
      }

      // remove last character from string, aka ","
      if (newSleeps.isNotEmpty) {
        newSleeps = newSleeps.substring(0, newSleeps.length - 1);
      }

      // if the file is empty, don't append , at the start of the json!
      await newFile.writeAsString(
        newSleeps,
        mode: FileMode.write,
      );

      finishUp();
    } catch (err) {
      print(err);
    }
  }

  void finishUp() {
    Navigator.pop(context, {
      "reload": true,
      "newData": SleepModel(_startDate ?? DateTime.now(),
          _endDate ?? DateTime.now(), _rating, _notesField.text,
          id: _id)
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final routeData =
        ModalRoute.of(context)?.settings.arguments as AddTimePageArguments?;

    if (routeData != null && _loading) {
      setState(() {
        if (routeData.sleepData != null) {
          final SleepModel data = routeData.sleepData!;
          _startDate = data.startTime;
          _endDate = data.endTime;
          _rating = data.rating;
          _notesField.text = data.notes;
          _id = data.id;

          _loading = false;
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 30.0, bottom: 30),
        child: Column(
          children: [
            // Add dates
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MaterialButton(
                  onPressed: () => _getNewDateTime(true),
                  color: theme.primary,
                  child: Text(_startDate == null
                      ? "Start Time"
                      : DateFormat("dd MMM yy | HH:mm").format(_startDate!)),
                ),
                MaterialButton(
                  onPressed:
                      _startDate == null ? null : () => _getNewDateTime(false),
                  disabledColor: Colors.grey[400],
                  color: theme.primary,
                  child: Text(_endDate == null
                      ? "End Time"
                      : DateFormat("dd MMM yy | HH:mm").format(_endDate!)),
                ),
                if (_endDate != null && _startDate != null)
                  Text(
                    _getTimeHHMMStr(
                      _endDate!.difference(_startDate!).inMinutes,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),

            // Add rating
            Container(
              alignment: Alignment.center,
              child: RatingBar.builder(
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.yellow[200],
                ),
                initialRating: _rating.toDouble(),
                onRatingUpdate: (double rating) {
                  setState(() {
                    _rating = rating.round();
                  });
                },
              ),
            ),
            const SizedBox(height: 20),

            // Add notes
            Input(
              title: "Notes",
              maxLines: 4,
              contollerItem: _notesField,
            ),
            const SizedBox(height: 20),

            // Save/Cancel
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MaterialButton(
                  onPressed: () => Navigator.pop(context, {"reload": false}),
                  disabledColor: Colors.grey[400],
                  color: theme.primary,
                  child: const Text("Cancel"),
                ),
                MaterialButton(
                  onPressed: _allowSave()
                      ? _id == null
                          ? _saveData
                          : _editData
                      : null,
                  color: theme.primary,
                  disabledColor: Colors.grey[400],
                  child: const Text("Save"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (_error["show"])
              Text(
                _error["message"],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.red[400],
                  letterSpacing: 0.5,
                ),
              )
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      backgroundColor: Colors.grey[900],
    );
  }
}
